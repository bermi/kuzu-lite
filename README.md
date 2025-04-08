# kuzu-lite

A lightweight fork of the [Kùzu](https://github.com/kuzudb/kuzu) embedded graph database, optimized for faster installation and broader compatibility.

## What is Kùzu?

Kùzu is a high-performance embedded graph database management system designed for efficient graph data storage and querying. It supports property graphs and the openCypher query language.

## Why We Forked Kùzu

- **Large Package Size:** The official Kùzu npm package exceeds 100MB, resulting in slow downloads and build times, particularly outside Europe and North America. **kuzu-lite** strips it down to essential binaries for a smaller, faster package.

- **No Alpine Linux Support:** The official Kùzu package doesn't support Alpine Linux, which is critical for lightweight Docker containers. **kuzu-lite** includes musl libc-compatible binaries to work seamlessly with Alpine Linux environments.

## Benefits

- **Smaller Footprint:** Significantly reduced package size for faster downloads and deployments.

- **Broader Compatibility:** Full support for Alpine Linux and musl libc environments.

- **Faster Integration:** Reduced build times in CI/CD pipelines and development workflows.

- **Same Core Power:** Retains all of Kùzu's essential functionality and performance in a leaner package.

## Installation

```bash
npm install kuzu-lite
# or
yarn add kuzu-lite
```

## Usage

```javascript
const kuzu = require('kuzu-lite');
const path = require("path");

(async () => {
  // Create an empty on-disk database and connect to it
  const db = new kuzu.Database(path.join(__dirname, "./demo_db"));
  const conn = new kuzu.Connection(db);
  try {
    await conn.query(`
      CREATE NODE TABLE Movie (name STRING, PRIMARY KEY(name));
      CREATE NODE TABLE Person (name STRING, birthDate STRING, PRIMARY KEY(name));
      CREATE REL TABLE ActedIn (FROM Person TO Movie);
      CREATE (:Person {name: 'Al Pacino', birthDate: '1940-04-25'});
      CREATE (:Person {name: 'Robert De Nero', birthDate: '1943-08-17'});
      CREATE (:Movie {name: 'The Godfather: Part II'})");
      MATCH (p:Person), (m:Movie) WHERE p.name = 'Al Pacino' AND m.name = 'The Godfather: Part II' CREATE (p)-[:ActedIn]->(m);
      MATCH (p:Person), (m:Movie) WHERE p.name = 'Robert De Nero' AND m.name = 'The Godfather: Part II' CREATE (p)-[:ActedIn]->(m);
      `)
  } catch (e) {
    console.error("Create DB failed:",e.message);
  }

  const queryResult = await conn.query("MATCH (p)-[:ActedIn]->(m) RETURN *");

  // Get all rows from the query result
  const rows = await queryResult.getAll();

  // Print the rows
  for (const row of rows) {
    console.log(row);
  }

})();


```

## Compatibility

kuzu-lite is tested on:
- Linux (glibc and musl libc)
- macOS (Intel and Apple Silicon)
- Windows

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the same license as Kùzu. See [LICENSE](LICENSE) file for details.