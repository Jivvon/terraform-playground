# Private archive Object Storage

`terragrunt/jwjeong127/archive` reuses this repository's OCI provider generation
and credential selectors from the Git-excluded `terraform.tfvars.json`.
It provisions one `blog-archive` bucket in the configured compartment.
No compute, network, IAM user, credential or existing bucket is changed.

OCI defaults already provide NoPublicAccess, Standard storage, encryption and
disabled auto-tiering/versioning. The module specifies only the required bucket
fields. OCI's default refusal to delete a nonempty bucket remains in effect;
archive data should also have a separate backup.

## Free allowance and configuration

Confirm `backend.jwjeong127.region` is the tenancy home region before applying
this isolated unit. Verify billing/account status and existing usage: an Always
Free-only account receives 20 GB combined Standard/Infrequent Access/Archive;
paid/trial accounts receive 10 GB per tier. Both allowances include 50,000 monthly
Object Storage API requests, shared with other usage.
[Official limits](https://docs.oracle.com/en-us/iaas/Content/FreeTier/freetier_topic-Always_Free_Resources.htm).

Use Standard storage for immediate reading. No restore-delay Archive tier,
replication, object events or versioning is enabled. Application snapshots
preserve old content revisions without bucket versioning. The free allowance
is not a per-bucket quota or a hard spending cap for a paid tenancy.

The current execution environment has no OCI config/private key or populated
Terraform tfvars. Provider schema validation is possible, but an authenticated
plan, quota check and apply have not been performed.

```sh
cd terragrunt/jwjeong127/archive
terragrunt init
terragrunt plan
```

Review that only one bucket is added, then apply that unit through the existing
workflow. Persist its state using the established private Terraform state
location; this unit follows the repository's current state convention.
If the bucket already exists, import `n/<namespace>/b/blog-archive` first.
Use the `archive` output's namespace and bucket in the private blog manifests.

## Runtime authentication

The blog uses native OCI signed requests, so it needs no S3 Customer Secret Key
or public pre-authenticated request. Use dedicated API-key identities rather than
the Terraform administrator. Provision keys and Kubernetes Secrets through the
existing secret workflow; keys are never generated into Terraform state here.

Example bucket-scoped IAM policy statements (substitute existing IAM group/domain
names and the actual compartment OCID):

```text
Allow group <reader-group> to read objects in compartment id <compartment-ocid> where target.bucket.name = 'blog-archive'
Allow group <writer-group> to manage objects in compartment id <compartment-ocid> where all {target.bucket.name = 'blog-archive', any {request.permission = 'OBJECT_INSPECT', request.permission = 'OBJECT_READ', request.permission = 'OBJECT_CREATE', request.permission = 'OBJECT_OVERWRITE'}}
```

These are examples, not applied policies. Verify the users' other group
memberships do not grant wider access. Native PUT of the shared index requires
OBJECT_OVERWRITE. Object deletion and bucket management are unnecessary for
either runtime role.
[OCI permission reference](https://docs.oracle.com/en-us/iaas/Content/Identity/policyreference/objectstoragepolicyreference.htm).

`Jivvon/gitops/apps/blog-dev` documents mounted config/key Secrets and rollout.
The public blog build never receives these credentials or archive objects.
