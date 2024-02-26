#!/bin/bash

# Expected response
expected="<!doctype html>
<html lang=\"en\">
	<head>
		<meta charset=\"utf-8\">
		<title>JSONSchemaDiscovery</title>
		<base href=\"/\">
		<meta name=\"viewport\" content=\"width=device-width, initial-scale=1\">
		<link rel=\"icon\" type=\"image/x-icon\" href=\"./assets/favicon.ico\"/>
		<link href=\"https://fonts.googleapis.com/icon?family=Material+Icons\" rel=\"stylesheet\">
	  <link rel=\"preconnect\" href=\"https://fonts.gstatic.com\">
  <link href=\"https://fonts.googleapis.com/css2?family=Roboto:wght@300;400;500&amp;display=swap\" rel=\"stylesheet\">
<link rel=\"stylesheet\" href=\"styles.css\"></head>
	<body class=\"mat-typography\">
		<app-root></app-root>
	<script src=\"runtime.js\" type=\"module\"></script><script src=\"polyfills.js\" type=\"module\"></script><script src=\"styles.js\" defer></script><script src=\"vendor.js\" type=\"module\"></script><script src=\"main.js\" type=\"module\"></script></body>
</html>"

# Function to check if server is online
check_server() {
  response=$(curl -s http://localhost:4200)
  if [[ "$response" == $expected ]]; then
    echo "Server is online and responsive"
    pkill -SIGTERM node
    return 0
  else
    echo "Server is not responding yet, retrying..."
    sleep 10
    return 1
  fi
}

# Start server
cd JSONSchemaDiscovery/
npm run dev &

# Wait for server to be online
while ! check_server; do
  continue
done

# Run experiments

# Copy results to report directory

# Create the report
cd ../RepEngReport/
make report
