## Vault

We use [Vault](https://vaultproject.io/) for for securely accessing secrets.

The main decision behind choosing Vault is its easy integration with Consul as a [secret backend](https://vaultproject.io/docs/secrets/index.html).

Vault provides "a unified interface to any secret, while providing tight access control and recording a detailed audit log".

Vault credentials are autogenerate and stored in vault-security.yaml i.e root_roken and keys.
