# downward_api
24년 kt kubernetes 교육


# 과제 1 Downward API 를 사용하여 pod 생성

   1-1 github 에 신규 repository 생성 ( downward_api )

   1-2 flask 사용하는 python 을 생성한다. downwardApi 에서 POD_NAME, NODE_NAME, POD_NAMESPACE 가져 와야함 (app.py)

   1-3 Dockerfile 화일 생성 ( 기존 베이스 이미지에 curl 모듈 추가 )

   1.4 Github Action 으로 github 에 이미지 push ( multi platform 지원 )

   1.5 downward_api.yaml 에 생성한 도커 이미지로 default namespace에 배포

   1.6 결과물

      jakelee@jake-MacBookAir ~ % kubectl exec -it downward-env -- curl localhost:5000

      Container EDU | POD Working : downward-env | nodename : lima-rancher-desktop | namespace : default


 

### 공유 : github action with multi platform ( platform option 을 주면 Intel/Silicon Mac 에서 다 동작함.

### docker_multi_platform.yaml


 
<pre><code>
name: Publish Docker Multi Platform GitHub image


# This workflow uses actions that are not certified by GitHub.

# They are provided by a third-party and are governed by

# separate terms of service, privacy policy, and support

# documentation.

 

on:     

  workflow_dispatch:

    inputs:

      name:

        description: "Docker TAG"

        required: true

        default: "master"

#  schedule:

#    - cron: '25 2 * * *'

#  push:

#    branches: [ master ]

#    # Publish semver tags as releases.

#    tags: [ 'v*..*.*' ]

#  pull_request:

#    branches: [ master ]


 

env:

  # Use docker.io for Docker Hub if empty

  REGISTRY: ghcr.io

  # github.repository as <account>/<repo>

  IMAGE_NAME: ${{ github.repository }}


 

jobs:

  build:

    runs-on: ubuntu-latest

    permissions:

      contents: read

      packages: write

      # This is used to complete the identity challenge

      # with sigstore/fulcio when running outside of PRs.

      id-token: write


 

    steps:

      - name: Checkout repository

        uses: actions/checkout@v3

      - name: QEMU Emulator

        uses: docker/setup-qemu-action@v3


 

      # Install the cosign tool except on PR

      # https://github.com/sigstore/cosign-installer

      - name: Install cosign

        if: github.event_name != 'pull_request'

        uses: sigstore/cosign-installer@v3.7.0 #sigstore/cosign-installer@d6a3abf1bdea83574e28d40543793018b6035605

        #with:

        #  cosign-release: 'v1.7.1'


 

      # Workaround: https://github.com/docker/build-push-action/issues/461

      - name: Setup Docker buildx

        uses: docker/setup-buildx-action@79abd3f86f79a9d68a23c75a09a9a85889262adf


 

      # Login against a Docker registry except on PR

      # https://github.com/docker/login-action

      - name: Log into registry ${{ env.REGISTRY }}

        if: github.event_name != 'pull_request'

        uses: docker/login-action@28218f9b04b4f3f62068d7b6ce6ca5b26e35336c

        with:

          registry: ${{ env.REGISTRY }}

          username: ${{ github.actor }}

          password: ${{ secrets.GITHUB_TOKEN }}

          platforms: linux/amd64,linux/arm64


 

      # Extract metadata (tags, labels) for Docker

      # https://github.com/docker/metadata-action

      - name: Extract Docker metadata

        id: meta

        uses: docker/metadata-action@98669ae865ea3cffbcbaa878cf57c20bbf1c6c38

        with:

          images: ${{ env.REGISTRY }}/${{ env.IMAGE_NAME }}

          tags: ${{ github.event.inputs.name }}


 

      # Build and push Docker image with Buildx (don't push on PR)

      # https://github.com/docker/build-push-action

      - name: Build and push Docker image

        id: build-and-push

        uses: docker/build-push-action@ac9327eae2b366085ac7f6a2d02df8aa8ead720a

        with:

          context: .

          push: ${{ github.event_name != 'pull_request' }}

          tags: ${{ steps.meta.outputs.tags }}

          labels: ${{ steps.meta.outputs.labels }}

          platforms: linux/amd64,linux/arm64

  </code></pre>


 

### downward_api.yaml 일부 ( 본인의 도커이미지로 교체 )


jakelee@jake-MacBookAir ~ % cat downward_test.yaml

apiVersion: v1

kind: Pod

metadata:

  name: downward-env

spec:

  containers:

  - name: main

    imagePullPolicy: Always

    image: ghcr.io/shclub/downward_api:v2

    #command: ["sleep", "99999"]
