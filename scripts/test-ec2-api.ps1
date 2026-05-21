# Test public EC2 deployment (default internship instance)
param([string]$Base = "http://13.48.42.252:8080")

Invoke-RestMethod -Uri "$Base/health" | Out-Null
$email = "ec2test_$(Get-Random)@example.com"
$reg = Invoke-RestMethod -Uri "$Base/api/auth/register" -Method Post -Body (@{
  name = "EC2 Test"; email = $email; password = "test123456"
} | ConvertTo-Json) -ContentType "application/json"
$h = @{ Authorization = "Bearer $($reg.token)" }
$task = Invoke-RestMethod -Uri "$Base/api/tasks" -Method Post -Body (@{
  title = "EC2"; description = "ok"; status = "todo"; priority = "medium"
} | ConvertTo-Json) -ContentType "application/json" -Headers $h
Invoke-RestMethod -Uri "$Base/api/tasks/$($task.task._id)" -Method Delete -Headers $h | Out-Null
Write-Host "OK: $Base health + register + task CRUD"
