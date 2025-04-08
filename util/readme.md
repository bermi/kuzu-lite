## kuzu-lite
A lightweight fork of the [Kùzu](https://github.com/kuzudb/kuzu) embedded graph database, optimized for faster installation and broader compatibility.

### Why We Forked Kùzu

- ***Large Package Size:*** 
The official Kùzu npm package exceeds 100MB, resulting in slow downloads and build times, particularly outside Europe and North America.
**kuzu-lite** strips it down to essential binaries for a smaller, faster package.

- ***No Alpine Linux Support:***
 Kùzu doesn’t support Alpine Linux, which we rely on for Docker image. 
 **kuzu-lite** includes musl libc-compatible binaries to work seamlessly with lightweight containers.


### Benefits

- ***Speed:*** Quicker downloads and builds.

- ***Compatibility:*** Full support for Alpine Linux.

- ***Efficiency:*** Retains Kùzu’s core functionality in a leaner package.

This version is straightforward, highlights the key issues with the official Kùzu package, and explains the advantages of **kuzu-lite** in a way that’s easy for users to understand. Feel free to tweak it as needed!