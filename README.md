## Notifier for Gitlab CI/CD Pipeline
Shell script using [curl](https://curl.se/) and Gitlab CI Variables to post messages on Merge Requests

### Gitlab CI/CD Pipeline
See the [.gitlab-ci.yml](.gitlab-ci.yml) for the example and the [execution](https://gitlab.com/ferrgo/gitlab-ci-notifier/-/merge_requests/3)

### Usage
The script looks for the following variables:
- `TOKEN`: API Token, see [Personal access tokens](https://docs.gitlab.com/ee/user/profile/personal_access_tokens.html#personal-access-tokens) or [Project access tokens](https://docs.gitlab.com/ee/user/project/settings/project_access_tokens.html)
- `CI_API_V4_URL`: API URL, always available on Gitlab Pipelines, see [Predefined variables reference](https://docs.gitlab.com/ee/ci/variables/predefined_variables.html#predefined-variables-reference)
- `CI_PROJECT_ID`: Unique id of the project, see [Predefined variables reference](https://docs.gitlab.com/ee/ci/variables/predefined_variables.html#predefined-variables-reference)
- `CI_MERGE_REQUEST_IID` or `CI_OPEN_MERGE_REQUESTS`: Variable for Merge Request ID, see [Predefined variables reference](https://docs.gitlab.com/ee/ci/variables/predefined_variables.html#predefined-variables-reference) or [Predefined variables for merge request pipelines](https://docs.gitlab.com/ee/ci/variables/predefined_variables.html#predefined-variables-for-merge-request-pipelines)
- `COMMENT_MSG`: Message to post on MR

#### Shell Usage
`cd src/ && ./notifier.sh`

#### Docker Usage
You can run using the docker image available on Docker Hub or GHCR

`docker run -e TOKEN=<TOkEN> -e CI_API_V4_URL=<URL> -e CI_PROJECT_ID=<ProjectID> -e CI_MERGE_REQUEST_IID=<MRID> -e COMMENT_MSG=<YourMessage> ferrgo/gitlab-ci-notifier`

### Docker image
Publishing to Docker Hub @ [ferrgo/gitlab-ci-notifier](https://hub.docker.com/r/ferrgo/gitlab-ci-notifier)

Publishing to Github Pkgs @ [docker.pkg.github.com/ferrgo/gitlab-ci-notifier/gitlab-ci-notifier](https://github.com/ferrgo/gitlab-ci-notifier/packages)

Publishing to Github Container Registry @ [ghcr.io/ferrgo/curlybox](https://github.com/users/ferrgo/packages/container/package/gitlab-ci-notifier)