# Lighthouse Stats for CircleCI

[![CircleCI](https://circleci.com/gh/rvshare/lighthouse-stats.svg?style=svg)](https://circleci.com/gh/rvshare/lighthouse-stats)

CircleCI orb for generating a historical record of how a site performs against Google's Lighthouse reporting tool. This will update a `LIGHTHOUSE_REPORTS.md` file in your repository after Lighthouse runs.

Make sure you start out with an empty `LIGHTHOUSE_REPORTS.md` file and `stats` folder to get started with this orb.

### SSH Key

This generates the SSH key to be registered with CircleCI and GitHub. There are some more comprehensive guides out there that may be of help as well.

```sh-session
$ openssl genrsa -out xxx 4096
$ sudo chmod 600 xxx
$ ssh-keygen -y -f xxx > xxx.pub
```

## Generate `.circleci/config.yml`

1. `$ wget https://raw.githubusercontent.com/rvshare/lighthouse-stats/master/src/generate_config.rb`
1. Edit the `urls` array in `generate_config.rb`
1. `$ ruby generate_config.rb`
1. Edit `CHANGEME` in the newly generated yaml file

## Manual Trigger

```sh-session
$ curl -X POST --header "Content-Type: application/json" -d '{"branch":"staging"}' https://circleci.com/api/v1.1/project/:vcs-type/:username/:project/build?circle-token=:token

# Example
$ curl -X POST --header "Content-Type: application/json" -d '{"branch":"master"}' https://circleci.com/api/v1.1/project/github/rvshare/lighthouse-stats-demo/build?circle-token=MY-CIRCLE-TOKEN

{
  "status" : 200,
  "body" : "Build created"
}
```

Note: You have to trigger the workflow instead of individual jobs.

See: https://circleci.com/docs/api/v1-reference/#new-project-build
