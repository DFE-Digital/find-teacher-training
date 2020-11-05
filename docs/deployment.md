# Deployment

The application is hosted on [GOV.UK PaaS](https://login.london.cloud.service.gov.uk) in the London region and has the below three environments:

| Environment   | Space       | URL |
| ------------- | ------------|---- |
| QA            | bat-qa      | https://qa.find-postgraduate-teacher-training.service.gov.uk       |
| Staging       | bat-staging | https://staging.find-postgraduate-teacher-training.service.gov.uk  |
| Production    | bat-prod    | https://www.find-postgraduate-teacher-training.service.gov.uk      |

Application is built and deployed to these environments using [GitHub Actions](https://github.com/DFE-Digital/find-teacher-training/actions).
<br/>
<br/>

## Deployment Process
All PRs merged will be continuously deployed to `Production` using the below workflow.

![Deployment Process](./deploy-workflow.png "GitHub Actions Workflow")

- A build is triggered for the merged PR commit and the tagged docker image is published to DockerHub, a QA deployment is next triggered (see [build.yml](/.github/workflows/build.yml))
- Once a successful deployment to QA is complete, the workflow triggers a smoke test run for the environment and awaits a successful completion of smoke tests
- Upon completion of the above, the workflow triggers the deployment to the next environment
- The merged PR commit is finally deployed to `Production`. (see [deploy.yml](/.github/workflows/deploy.yml))
- You can view the current deployed commit in each of the environments

<a href="https://github.com/DFE-Digital/find-teacher-training/deployments">![Environments](./deployments.png "GitHub Actions Workflow")</a>
