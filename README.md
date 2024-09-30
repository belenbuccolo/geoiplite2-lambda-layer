# GeoLite2 Lambda Layer

## How to create the layer zip file to be used in AWS Lambda

1. Clone the repository:

2. Create a `.env` file in the project root with your MaxMind credentials:

   ```
   MAXMIND_LICENSE_KEY=your_license_key_here
   MAXMIND_USER_ID=your_account_id_here
   ```

3. Make the build script executable:
   ```
   chmod +x build_layer.sh
   ```

## Building the Lambda Layer

Run the build script:

```
./build_layer.sh
```

## Deploying the Layer

After building, the layer can be deployed using the cli, the AWS console or the serverless framework.

## Usage in Lambda Functions

After deploying, the layer can be used with:

```javascript
const maxmind = require("maxmind");

exports.handler = async (event) => {
  const dbPath = "/opt/maxminddb/GeoLite2-City.mmdb";
  const lookup = await maxmind.open(dbPath);

  const ip = event.ip || "8.8.8.8";
  const result = lookup.get(ip);

  return {
    statusCode: 200,
    body: JSON.stringify(result),
  };
};
```
