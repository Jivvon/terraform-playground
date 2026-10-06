# Private blog DNS

This isolated Terraform root creates only the DNS-only A record for
`blog.dev.jwjeong127.com`. It does not use the OCI/Terragrunt root and does not
manage existing admin, Argo CD, apex or public blog records.

`ttl = 1` is required by the provider and selects automatic TTL. The provider's
default `proxied = false` supplies DNS-only behavior without a redundant field.

The default address is the public DNS answer observed for `admin.jwjeong127.com`
on 2026-10-06: `100.122.136.74`. Verify it still reaches the intended nginx
Ingress over Tailscale before applying. HTTPS is terminated there using the
existing cert-manager `letsencrypt-dns01` issuer, not Cloudflare edge SSL.

Supply a zone-scoped `CLOUDFLARE_API_TOKEN` through your secret manager or execution
environment. It needs DNS Edit, plus Zone Read when discovering the zone ID.
Do not commit tokens, populated tfvars, plans or state. Persist/back up this root's
state in the established private Terraform state location before ongoing use;
it starts with the default local backend and does not migrate any existing state.

```sh
terraform -chdir=cloudflare/blog-dev init
terraform -chdir=cloudflare/blog-dev validate
terraform -chdir=cloudflare/blog-dev plan -var='zone_id=YOUR_ZONE_ID' -out=blog-dev.tfplan
```

Inspect the plan: only one DNS record should be added. If a record already exists,
import its observed ID before planning rather than creating a duplicate:

```sh
terraform -chdir=cloudflare/blog-dev import -var='zone_id=YOUR_ZONE_ID' \
  cloudflare_dns_record.blog_dev 'ZONE_ID/RECORD_ID'
```

Apply the reviewed plan only after the private Ingress is ready:

```sh
terraform -chdir=cloudflare/blog-dev apply blog-dev.tfplan
```

Rollback can update this record to a prior verified private address. Disabling the new blog Ingress closes
the service without changing existing services or deleting archived data.
