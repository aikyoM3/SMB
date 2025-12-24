"""
Locust load testing file for Bank Management Application
This file tests the microservices through the gateway service.
"""

from locust import HttpUser, task, between, events
import logging
import json
import random
import string
import jwt
import base64

logger = logging.getLogger("locustfile")

# JWT secret key (must match the one in application.properties)
JWT_SECRET = "AaZzBbCcYyDdXxEeWwFf"

class BankUser(HttpUser):
    """
    Simulates a user interacting with the bank application.
    Handles authentication and maintains user context.
    """
    wait_time = between(1, 3)
    
    def on_start(self):
        """Called when a simulated user starts. Performs login and sets up user context."""
        self.token = None
        self.user_id = None
        self.customer_id = None
        self.account_id = None
        self.username = None
        
        # Try to login with test user
        self.login()
        
        # If login successful and we have user_id, proceed with setup
        if self.token and self.user_id:
            self.get_user_profile()
            # Get or create customer and account
            self.setup_customer_and_account()
        else:
            logger.warning("Failed to authenticate or extract user_id. Some tests may fail.")
            # Still try to get existing customers/accounts if available
            if not self.customer_id:
                self.get_existing_customer()
            if self.customer_id and not self.account_id:
                self.get_or_create_account()
    
    def decode_jwt(self, token):
        """Decode JWT token to extract user information."""
        try:
            # Decode without verification first to get the payload
            # Then we can verify if needed
            decoded = jwt.decode(token, JWT_SECRET, algorithms=["HS256"], options={"verify_signature": True})
            return decoded
        except jwt.ExpiredSignatureError:
            logger.error("JWT token has expired")
            return None
        except jwt.InvalidTokenError as e:
            logger.error(f"Invalid JWT token: {e}")
            return None
    
    def login(self):
        """Authenticate user and get JWT token."""
        # Use a test user - you may need to create this user first
        login_data = {
            "username": "testuser",
            "password": "testpass123"
        }
        
        with self.client.post(
            "/AUTHENTICATION-SERVICE/bank/authentication/login",
            json=login_data,
            catch_response=True,
            name="Login"
        ) as response:
            if response.status_code == 200:
                try:
                    data = response.json()
                    self.token = data.get("token")
                    if self.token:
                        # Extract user_id from JWT token
                        decoded = self.decode_jwt(self.token)
                        if decoded:
                            self.user_id = decoded.get("id")
                            self.username = decoded.get("sub")  # subject is username
                            logger.info(f"Login successful, user_id: {self.user_id}, username: {self.username}")
                        response.success()
                    else:
                        logger.warning("Login response missing token")
                        response.failure("No token in response")
                except Exception as e:
                    logger.error(f"Error parsing login response: {e}")
                    response.failure(f"Error parsing response: {e}")
            else:
                logger.warning(f"Login failed with status {response.status_code}")
                # Try alternative test users
                self.try_alternative_login()
                response.failure(f"Login failed: {response.status_code}")
    
    def try_alternative_login(self):
        """Try alternative login credentials."""
        alternatives = [
            {"username": "admin", "password": "admin"},
            {"username": "user", "password": "user"},
        ]
        
        for creds in alternatives:
            with self.client.post(
                "/AUTHENTICATION-SERVICE/bank/authentication/login",
                json=creds,
                catch_response=True,
                name="Alternative Login"
            ) as response:
                if response.status_code == 200:
                    try:
                        data = response.json()
                        self.token = data.get("token")
                        if self.token:
                            decoded = self.decode_jwt(self.token)
                            if decoded:
                                self.user_id = decoded.get("id")
                                self.username = decoded.get("sub")
                                logger.info(f"Alternative login successful, user_id: {self.user_id}")
                                return
                    except Exception as e:
                        logger.error(f"Error in alternative login: {e}")
                        continue
    
    def create_test_user(self):
        """Create a test user if it doesn't exist."""
        # This would require admin access or a registration endpoint
        # For now, we'll use a fallback approach
        logger.info("Attempting to create test user...")
        # Note: This might require admin privileges or a registration endpoint
    
    def get_user_profile(self):
        """Get user profile to verify user information."""
        if not self.token or not self.user_id:
            logger.warning("Cannot get user profile - no token or user_id")
            return
        
        headers = {"Authorization": f"Bearer {self.token}"}
        
        with self.client.get(
            "/AUTHENTICATION-SERVICE/bank/users/profile",
            headers=headers,
            catch_response=True,
            name="Get User Profile"
        ) as response:
            if response.status_code == 200:
                try:
                    data = response.json()
                    # Verify user_id matches
                    profile_user_id = data.get("id")
                    if profile_user_id and profile_user_id != self.user_id:
                        logger.warning(f"User ID mismatch: token={self.user_id}, profile={profile_user_id}")
                        self.user_id = profile_user_id
                    logger.info(f"User profile retrieved, user_id: {self.user_id}")
                    response.success()
                except Exception as e:
                    logger.error(f"Error parsing user profile: {e}")
                    response.failure(f"Error parsing response: {e}")
            else:
                logger.warning(f"Failed to get user profile: {response.status_code}")
                # Don't fail completely, we already have user_id from JWT
                response.failure(f"Failed to get profile: {response.status_code}")
    
    def setup_customer_and_account(self):
        """Setup customer and account for testing."""
        if not self.user_id:
            logger.warning("Cannot setup customer - user_id is None")
            return
        
        # Try to get existing customer by user_id or create one
        self.get_or_create_customer()
        
        if self.customer_id:
            self.get_or_create_account()
    
    def get_or_create_customer(self):
        """Get existing customer or create a new one."""
        if not self.token:
            logger.warning("Cannot get customer - no authentication token")
            return
            
        if not self.user_id:
            logger.warning("Cannot get customer - user_id is None")
            return
        
        # Try to search for customer first
        headers = {"Authorization": f"Bearer {self.token}"}
        
        # Search customers (this might require admin access)
        # For now, create a customer
        customer_data = {
            "name": f"Test Customer {self.user_id[:8]}",
            "email": f"test{self.user_id[:8]}@example.com",
            "cin": f"CIN{self.user_id[:8]}",
            "phone": f"+1234567890",
            "address": "123 Test Street"
        }
        
        with self.client.post(
            "/CUSTOMER-SERVICE/bank/customers/create",
            json=customer_data,
            headers=headers,
            catch_response=True,
            name="Create Customer"
        ) as response:
            if response.status_code in [200, 201]:
                try:
                    data = response.json()
                    self.customer_id = data.get("id")
                    logger.info(f"Customer created/retrieved, customer_id: {self.customer_id}")
                    response.success()
                except Exception as e:
                    logger.error(f"Error parsing customer response: {e}")
                    response.failure(f"Error parsing response: {e}")
            else:
                # Try to get existing customer
                logger.info("Customer creation failed, trying to get existing customer")
                self.get_existing_customer()
                response.failure(f"Failed to create customer: {response.status_code}")
    
    def get_existing_customer(self):
        """Try to get an existing customer from the list."""
        if not self.token:
            logger.warning("Cannot get customer list - no authentication token")
            return
            
        headers = {"Authorization": f"Bearer {self.token}"}
        
        with self.client.get(
            "/CUSTOMER-SERVICE/bank/customers/list?page=0&size=1",
            headers=headers,
            catch_response=True,
            name="Get Customer List"
        ) as response:
            if response.status_code == 200:
                try:
                    data = response.json()
                    customers = data.get("content", [])
                    if customers:
                        self.customer_id = customers[0].get("id")
                        logger.info(f"Retrieved existing customer, customer_id: {self.customer_id}")
                except Exception as e:
                    logger.error(f"Error parsing customer list: {e}")
    
    def get_or_create_account(self):
        """Get existing account or create a new one."""
        if not self.token:
            logger.warning("Cannot get account - no authentication token")
            return
            
        if not self.customer_id:
            logger.warning("Cannot get account - customer_id is None")
            return
        
        headers = {"Authorization": f"Bearer {self.token}"}
        
        # Try to get account by customer_id first
        with self.client.get(
            f"/ACCOUNT-SERVICE/bank/accounts/queries/find-account/{self.customer_id}",
            headers=headers,
            catch_response=True,
            name="Get Account by Customer ID"
        ) as response:
            if response.status_code == 200:
                try:
                    data = response.json()
                    self.account_id = data.get("id")
                    logger.info(f"Account retrieved, account_id: {self.account_id}")
                    response.success()
                    return
                except Exception as e:
                    logger.error(f"Error parsing account response: {e}")
            
            # If account doesn't exist, create one
            if response.status_code == 404:
                logger.info("Account not found, creating new account")
                account_data = {
                    "customerId": self.customer_id,
                    "currency": "USD"
                }
                
                with self.client.post(
                    "/ACCOUNT-SERVICE/bank/accounts/commands/create",
                    json=account_data,
                    headers=headers,
                    catch_response=True,
                    name="Create Account"
                ) as create_response:
                    if create_response.status_code in [200, 201]:
                        try:
                            # The response might be just the account ID
                            account_id = create_response.text.strip('"')
                            self.account_id = account_id
                            logger.info(f"Account created, account_id: {self.account_id}")
                            create_response.success()
                        except Exception as e:
                            logger.error(f"Error parsing create account response: {e}")
                            create_response.failure(f"Error parsing response: {e}")
                    else:
                        logger.warning(f"Failed to create account: {create_response.status_code}")
                        create_response.failure(f"Failed to create account: {create_response.status_code}")
            else:
                response.failure(f"Failed to get account: {response.status_code}")
    
    @task(3)
    def get_account(self):
        """Get account information."""
        if not self.token:
            logger.warning("Cannot get account - no authentication token")
            return
            
        if not self.account_id:
            logger.warning("Cannot get account - account_id is None")
            return
        
        headers = {"Authorization": f"Bearer {self.token}"}
        
        with self.client.get(
            f"/ACCOUNT-SERVICE/bank/accounts/queries/get-account/{self.account_id}",
            headers=headers,
            catch_response=True,
            name="Get Account"
        ) as response:
            if response.status_code == 200:
                response.success()
            else:
                response.failure(f"Failed to get account: {response.status_code}")
    
    @task(2)
    def get_account_by_customer_id(self):
        """Get account by customer ID."""
        if not self.token:
            logger.warning("Cannot get accounts - no authentication token")
            return
            
        if not self.customer_id:
            # Try to get customer_id from user_id if available
            if self.user_id:
                logger.info(f"Attempting to use user_id as customer_id: {self.user_id}")
                self.customer_id = self.user_id
            else:
                logger.warning("Cannot get accounts - user_id is None and customer_id is None")
                # Try to get any existing customer
                if not self.customer_id:
                    self.get_existing_customer()
                if not self.customer_id:
                    return
        
        headers = {"Authorization": f"Bearer {self.token}"}
        
        with self.client.get(
            f"/ACCOUNT-SERVICE/bank/accounts/queries/find-account/{self.customer_id}",
            headers=headers,
            catch_response=True,
            name="Get Account by Customer ID"
        ) as response:
            if response.status_code == 200:
                try:
                    data = response.json()
                    if data and data.get("id"):
                        self.account_id = data.get("id")
                    response.success()
                except Exception as e:
                    logger.error(f"Error parsing account response: {e}")
                    response.failure(f"Error parsing response: {e}")
            else:
                response.failure(f"Failed to get account: {response.status_code}")
    
    @task(2)
    def get_customer(self):
        """Get customer information."""
        if not self.token:
            logger.warning("Cannot get customer - no authentication token")
            return
            
        if not self.customer_id:
            logger.warning("Cannot get customer - customer_id is None")
            return
        
        headers = {"Authorization": f"Bearer {self.token}"}
        
        with self.client.get(
            f"/CUSTOMER-SERVICE/bank/customers/get/{self.customer_id}",
            headers=headers,
            catch_response=True,
            name="Get Customer"
        ) as response:
            if response.status_code == 200:
                response.success()
            else:
                response.failure(f"Failed to get customer: {response.status_code}")
    
    @task(1)
    def get_account_operations(self):
        """Get account operations."""
        if not self.token:
            logger.warning("Cannot get operations - no authentication token")
            return
            
        if not self.account_id:
            logger.warning("Cannot get operations - account_id is None")
            return
        
        headers = {"Authorization": f"Bearer {self.token}"}
        
        with self.client.get(
            f"/ACCOUNT-SERVICE/bank/accounts/queries/all-operations?accountId={self.account_id}&page=0&size=10",
            headers=headers,
            catch_response=True,
            name="Get Account Operations"
        ) as response:
            if response.status_code == 200:
                response.success()
            else:
                response.failure(f"Failed to get operations: {response.status_code}")
    
    @task(1)
    def credit_account(self):
        """Credit account with random amount."""
        if not self.token:
            logger.warning("Cannot credit account - no authentication token")
            return
            
        if not self.account_id:
            logger.warning("Cannot credit account - account_id is None")
            return
        
        headers = {"Authorization": f"Bearer {self.token}"}
        amount = round(random.uniform(10, 1000), 2)
        
        credit_data = {
            "accountId": self.account_id,
            "amount": amount
        }
        
        with self.client.post(
            "/ACCOUNT-SERVICE/bank/accounts/commands/credit",
            json=credit_data,
            headers=headers,
            catch_response=True,
            name="Credit Account"
        ) as response:
            if response.status_code in [200, 201]:
                response.success()
            else:
                response.failure(f"Failed to credit account: {response.status_code}")

