### Azure DevOps Pull Request Tigger Integration with Github

Pull requests (PRs) provide an effective way to have code reviewed before it is merged to the codebase. Pull request triggers enable us to create pull request releases that deploy the PR code or PR builds to detect deployment issues before the code changes are merged. 
We can use pull request triggers with code hosted on Azure Repos or GitHub. 
![Image of Azure DevOps Pull Request Tigger Integration with Github](https://https://raw.githubusercontent.com/DFE-Digital/find-teacher-training/2443-Add-Docs/docs/PRAzureGitHub.png)
 
Details of setting up PR based build and release pipelines is discussed in this article here in detail: https://docs.microsoft.com/en-us/azure/devops/pipelines/release/deploy-pull-request-builds?view=azure-devops
One of the details missing from most of the articles found online is the decommissioning of the resources that gets deployed for PR validation when the PR is merged or closed. 
To overcome that requirement, we could create a webhook API in Azure Function and configure Github webhook to send pull request�s payload to Azure Function to delete PR deployment from Azure when PR action is either �merged� or �closed�.
To achieve this, create an Azure Function App v2 with PowerShell Core runtime stack. Set the webhookType to Github and authLevel to anonymous. This will enable the Get function URL and Get GitHub secret on function app. Use this info to create a web hook in Github. When creating a Github webhook, for payload select �Let me select individual events.� and further select Pull requests events.
Write a PowerShell script in Azure Function App to handle the payload and take actions accordingly. PS script can be designed to return a status of the execution back to the Github as a payload response.
