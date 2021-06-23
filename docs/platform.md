# Platform

**Platform** allows you to turn a container image or Kubernetes YAML into a business in just a few minutes, turning your self-hosted projects into a PaaS!

By connecting a [Stripe](https://stripe.com/) account and choosing a [Template](/templates), your Platform will be able to accept user payments, spin up resources for customers, and allow those users to manage certain settings such as Environment Variables. With easy upgrades and payment processing options, KubeSail Platform is the fastest and easiest way to go from a container image to a business.

### Create a new Platform

<img src="/img/platform-new.png" width="60%" title="Create new Platform" />

Click "New Platform" and enter a name. Note that must be unique across all of KubeSail, and will be shown to your users when they sign-up!
<br />
<br />

### Step 1: Connect Stripe

<img src="/img/platform-stripe.png" width="60%" title="Connect Stripe Account" />

Customer's resources will be launched when they complete a payment. Payments are handled by Stripe and are processed through your account, which gives you complete control and transparency over the billing process and the status of your customers. A KubeSail fee will be added to each payment automatically, which can also be seen in your Stripe account.
<br />
<br />

### Step 2: Upload a logo

<img src="/img/platform-logo.png" width="60%" title="Upload a logo" />

Upload your logo, which will be visible on the [Customer Billing Portal](https://github.com/kubesail/kubesail-customer-platform). It's a good idea to use your main company logo here, so your users feel comfortable that they're in the right place!
<br />
<br />

### Step 3: Setting a price

<img src="/img/platform-price.png" width="60%" title="Set a Price" />

Set a name and a monthly price for this Plan. This will be displayed to your customers in the [Customer Billing Portal](https://github.com/kubesail/kubesail-customer-platform).

### Step 4: Where to deploy

When customers make a payment, their resources will need to be provisioned somewhere! KubeSail Platform makes this flexible and powerful, by allowing you a number of options:

  1. **Use Existing Cluster**: If you already have a Cluster attached to KubeSail, you can use it immediately. Please note that some precaution with regards to security is important here, but this choice is perfect for experts who are ready to manage their own Clusters.

  2. **Ship a Pibox**: We're building [pibox.io](https://pibox.io), which is a shippable Cluster-In-A-Box. These tiny systems can be pre-provisioned with a Template when a user makes a payment, and shipped directly to them! Perfect for easy on-prem deployments and other IoT purposes!

  3. **Cluster-per-Customer**: This option allows you to provision a private cluster for each customer who registers. This option is most useful for Enterprise offerings, for customers with more strict security tolerances, or in situations where a Template may need a huge amount of resources.

  4. **Order a Managed Cluster**: With this option, KubeSail experts will build a custom cluster for your Platform. We will handle cluster issues, monitoring, respond to alarms, and more! This is perfect if you're a developer who wants to focus on your software, and not on running the Platform.

For options **2**, **3** and **4**, we strongly recommend reaching out to us at support@kubesail.com so we can get things dialed in perfectly!

### Step 5: Choose a Template

<img src="/img/platform-template.png" width="60%" title="Choose Templates" />

When a user completes a Payment, a Template will be launched in a namespace created for that user. Note that customers will only be able to access their resources if an **Ingress** Object is defined in the template.

### Step 6: Template Variables

Variables from your [Template](/templates) are visible here, and can be modified to be **Visible** or **Required**, as well as setting a default Value.

<img src="/img/platform-templatevars.png" width="40%" title="Choose Templates" />

- **Visible** variables are displayed to your customers in the customer-portal as a settings portal. This allows customers to set their own

- **Required** variables must be completed by your customers before the Template will be launched. They're non-optional.

You can also set Default values, helper functions (like RANDOM to generate a random string), or human-friendly descriptions in your Template. See the [Template docs](/templates) for more information.

### Customer Portal

You can set the "Portal Domain" in your Platform which is the domain where Customers can sign up. A pre-hosted Customer Portal will be registered for you at `PLATFORM_NAME.kubesail.app`, which is a hosted instance of [this repo](https://github.com/kubesail/kubesail-customer-platform). Feel free to fork and customize that repo if you'd like to customize your Customer sign up experience. We're working on API documentation for further customization as well - please drop us a message at support@kubesail.com if you're interested!
