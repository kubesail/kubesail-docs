# Templates

**Templates** allow you to easily install and share applications.

Templates can be shared with others, re-used on your clusters, and used to create a [Platform](/platform) to resell your software! Check out our [Official templates](https://kubesail.com/templates?official=1) or see all [public templates](https://kubesail.com/templates) to get started!

### Creating a new Template

Visit [https://kubesail.com/template/new](https://kubesail.com//template/new).

### Getting started

- Choose **"Start with a Docker image"** if you have a public Docker image you'd like to use - we'll automatically generate most of the Kubernetes configuration you'll need!
- Choose **"Add a Deployment"** to see a minimal example of a Kubernetes Deployment
- Choose **"Edit YAML"** to open the built-in YAML Editor

### Public / Private
When you first save your new template, you can choose **public** or **private**.

- Public templates are visible to everyone - Be careful not to include sensitive information!
- Private templates are only visible to you and members of your organization

### Adding resources

You can add common Kubernetes resources using the **"+"** icon in the Editor.

![[Add resource](img/templates-add-resource.png)](img/templates-add-resource.png)

### Editing resources

You can use the YAML editor on the right to create any custom resource you'd like. However, for most common resource-types, you can also click on the resource on the left and use more friendly tools to modify the resources:

![[Left-hand editor](img/templates-lefthand.png)](img/templates-lefthand.png)

### Template Variables

You can create special variables that will require user-input before launching. This is very useful for configuration that will need to be different for each user who installs this template. Variables are formatted like `"{{ VARIABLE_NAME }}"`. Variables must be quoted, and can only be strings.

Creating a variable will automatically add the "Environment Variable" panel to the left-hand side:

![[Env vars](img/templates-envvars.png)](img/templates-envvars.png)

Environment variables can also be upgraded a bit to help users by giving them defaults and descriptions about how they should be used. The format is:

    "{{ VARIABLE_NAME|default value or function|Description|Friendly name }}"

You can also use `RANDOM(length)` as a default value to generate random strings such as passwords:

![[Variable functions](img/templates-varfunctions.png)](img/templates-varfunctions.png)

Variables which have no default value -must- be completed by a user before the Template can be launched.

As always, please let us know [in our discord channel](https://discord.gg/N3zNdp7jHc) if you have any questions or if you need a hand building an awesome template!

### Special Variables

Several variables, like `{{ CLUSTER_ADDRESS }}` are automatically replaced with contextual information that can be useful when creating well formed templates. For example, official templates typically include an `Ingress` which uses a default address like `app-name.{{ CLUSTER_ADDRESS }}`. Some others are available:

| Variable          | Replaced With                                                                                                                                     |
| ----------------- | ------------------------------------------------------------------------------------------------------------------------------------------------- |
| NAMESPACE         | The name of the users current namespace, ie: 'default'                                                                                            |
| USERNAME          | The KubeSail user's username                                                                                                                      |
| CLUSTER_ADDRESS   | The address of the current cluster, ie: 'pasadena.erulabs.usw1.k8g8.com'                                                                          |
| TZ                | The timezone of the users browser                                                                                                                 |
| HTACCESS_USERNAME | Used as a special input variable for the HTACCESS_AUTH() function. See [deluge](https://kubesail.com/template/erulabs/deluge-vpn) for an example. |
| HTACCESS_PASSWORD | Same as HTACCESS_USERNAME, but, the password.                                                                                                     |

### Variable Functions

Like special variables, variable functions can be used to create healthy defaults for users. The most commonly used is `{{ RANDOM(32) }}, which generates a random 32-character string, useful for passwords and tokens. Others are available:


| Variable        | Replaced With                                                                                                              |
| --------------- | -------------------------------------------------------------------------------------------------------------------------- |
| RANDOM(length)  | Random, url-safe string of size 'length'                                                                                   |
| SRANDOM(length) | Random, json-safe string of size 'length'                                                                                  |
| HEX(length)     | Random, hex-encoded string of size 'length'                                                                                |
| HTACCESS_AUTH   | Used to generate a valid htaccess document. See [deluge](https://kubesail.com/template/erulabs/deluge-vpn) for an example. |

Many of these functions have been added by request. Please let us know in discord if you have an idea for another useful one!
