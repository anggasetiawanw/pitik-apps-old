APP_ID = "1:98893830821:android:b291df0e7b0189d52bcb4c"
APP_GROUP = "TESTER"

export GOOGLE_APPLICATION_CREDENTIALS="distri_key.json"

RELEASE_NOTES=""

if [[ -z ${INPUT_RELEASENOTES} ]]; then
        RELEASE_NOTES="$(git log -1 --pretty=short)"



