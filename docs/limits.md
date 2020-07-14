# Limits

This section documents the limits of both shared cluster hosting and BYOC.

|                                               | Free         | Starter            | Teams            |
| --------------------------------------------- | ------------ | ------------------ | ---------------- |
| **RAM**                                       | 512MB        | 2048MB             | 4096MB, per user |
| **CPU**                                       | up to 1 vCPU | 1 vCPU, guaranteed | 4 vCPU, per user |
| **Private Docker Images** <sup>see note</sup> | 0            | 1                  | Unlimited        |
| **Users Per Namespace**                       | 1            | 3                  | Unlimited        |

<br>
#### Notes

The **Private Docker Image** limit refers to private repository images created by KubeSail's [Deploy-From-Git](/repo_builder/#step-3-deploy-from-github-repository) pipeline. Regardless of plan, there is no limit to the number of private images you may host if they are pulled from an external registry.
