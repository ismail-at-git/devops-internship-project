# Quick API checks when Docker stack is healthy (http://localhost:8080 via Nginx)
$base = "http://localhost:8080"
$email = "dockertest_$(Get-Random)@example.com"
$body = @{ name = "Docker Test"; email = $email; password = "test123456" } | ConvertTo-Json

Write-Host "Health via Nginx..."
Invoke-RestMethod -Uri "$base/health" -Method Get | ConvertTo-Json

Write-Host "Register..."
$reg = Invoke-RestMethod -Uri "$base/api/auth/register" -Method Post -Body $body -ContentType "application/json"
$token = $reg.token

Write-Host "Tasks CRUD..."
$headers = @{ Authorization = "Bearer $token" }
$task = @{ title = "Docker task"; description = "test"; status = "todo"; priority = "medium" } | ConvertTo-Json
$created = Invoke-RestMethod -Uri "$base/api/tasks" -Method Post -Body $task -ContentType "application/json" -Headers $headers
$id = $created.task._id
Invoke-RestMethod -Uri "$base/api/tasks" -Method Get -Headers $headers | Out-Null
Invoke-RestMethod -Uri "$base/api/tasks/$id" -Method Put -Body (@{ title = "Updated" } | ConvertTo-Json) -ContentType "application/json" -Headers $headers | Out-Null
Invoke-RestMethod -Uri "$base/api/tasks/$id" -Method Delete -Headers $headers | Out-Null

Write-Host "OK: register + task CRUD via Nginx proxy"
