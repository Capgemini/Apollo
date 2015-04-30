## Weave

We use [weave](zettio.github.io/weave/) to provide an overlay network for Docker containers.
This allows each Docker container to have its own IP address / port in the overlay network and for container to container communication to happen in the overlay network without the need for host port mapping or statically linking Docker containers together.

For more information on how networking works in Apollo see [networking](../networking.md)
