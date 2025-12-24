#!/bin/bash
# Script to create a test user for load testing
# This requires the authentication service to be running

GATEWAY_URL="http://localhost:8888"
AUTH_SERVICE="/AUTHENTICATION-SERVICE/bank"

echo "Creating test user for load testing..."

# Note: This script assumes you have admin access or a registration endpoint
# Adjust the endpoint and payload based on your actual API

# Example: Create user via admin endpoint (if available)
# curl -X POST "${GATEWAY_URL}${AUTH_SERVICE}/users/create" \
#   -H "Content-Type: application/json" \
#   -H "Authorization: Bearer YOUR_ADMIN_TOKEN" \
#   -d '{
#     "username": "testuser",
#     "password": "testpass123",
#     "email": "testuser@example.com",
#     "firstname": "Test",
#     "lastname": "User",
#     "cin": "TEST123456",
#     "placeOfBirth": "Test City",
#     "dateOfBirth": "1990-01-01",
#     "nationality": "Test",
#     "gender": "M"
#   }'

echo ""
echo "To create a test user manually:"
echo "1. Access the authentication service API"
echo "2. Use admin credentials to create a user with:"
echo "   - Username: testuser"
echo "   - Password: testpass123"
echo "   - Email: testuser@example.com"
echo ""
echo "Or use the application's registration endpoint if available."

