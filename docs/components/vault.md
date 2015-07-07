## Vault

We use [Vault](https://vaultproject.io/) for for securely accessing secrets.

The main decision behind choosing Vault is its easy integration with Consul as a [secret backend](https://vaultproject.io/docs/secrets/index.html).

Vault provides "a unified interface to any secret, while providing tight access control and recording a detailed audit log".

We use [App-id auth backend](https://vaultproject.io/docs/auth/app-id.html) as "a mechanism for dynamic machines, containers, etc. to authenticate with Vault. It works by requiring two hard-to-guess unique pieces of information: a unique app ID, and a unique user ID".

Apollo by default provides simple values for this pieces
E.g.

```
vault_weave_app_id: "weave"
vault_weave_user_id: 'ansible_hostname'
vault_weave_password: 'wEaVe'
```

This values can be overriden with environment variables in execution time.
like

```
export APOLLO_vault_weave_app_id="your_more_secure_app_id"
export APOLLO_vault_weave_user_id='your_more_secure_user_id'
export APOLLO_vault_weave_password='your_more_secure_weave_pass'
```

Vault credentials are autogenerate and stored in vault-security.yaml i.e root_roken and keys.