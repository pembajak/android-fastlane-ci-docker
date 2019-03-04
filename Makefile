IMAGE_NAME := babbicool/android-fastlane-ci

.PHONY=build
build:
	docker build --build-arg VCS_REF="`git rev-parse --short HEAD`" \
	--build-arg BUILD_DATE=`date -u +"%Y-%m-%dT%H:%M:%SZ"` \
	-t $(IMAGE_NAME) .

.PHONY=publish
publish:
	docker push babbicool/android-fastlane-ci

