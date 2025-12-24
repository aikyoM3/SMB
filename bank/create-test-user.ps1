# PowerShell script to create a test user for load testing
# This requires the authentication service to be running

$GATEWAY_URL = "http://localhost:8888"
$AUTH_SERVICE = "/AUTHENTICATION-SERVICE/bank"

Write-Host "Creating test user for load testing..." -ForegroundColor Yellow

# Note: This script assumes you have admin access or a registration endpoint
# Adjust the endpoint and payload based on your actual API

# Example: Create user via admin endpoint (if available)
# $body = @{
#     username = "testuser"
#     password = "testpass123"
#     email = "testuser@example.com"
#     firstname = "Test"
#     lastname = "User"
#     cin = "TEST123456"
#     placeOfBirth = "Test City"
#     dateOfBirth = "1990-01-01"
#     nationality = "Test"
#     gender = "M"
# } | ConvertTo-Json

# Invoke-RestMethod -Uri "${GATEWAY_URL}${AUTH_SERVICE}/users/create" `
#     -Method Post `
#     -ContentType "application/json" `
#     -Headers @{Authorization = "Bearer YOUR_ADMIN_TOKEN"} `
#     -Body $body

Write-Host ""
Write-Host "To create a test user manually:" -ForegroundColor Cyan
Write-Host "1. Access the authentication service API"
Write-Host "2. Use admin credentials to create a user with:"
Write-Host "   - Username: testuser"
Write-Host "   - Password: testpass123"
Write-Host "   - Email: testuser@example.com"
Write-Host ""
Write-Host "Or use the application's registration endpoint if available." -ForegroundColor Yellow

