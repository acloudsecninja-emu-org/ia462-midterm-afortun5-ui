docker run -d \
  --name midterm-container \
  --read-only \
  --tmpfs /tmp \
  --cap-drop ALL \
  --security-opt no-new-privileges:true \
  --security-opt seccomp=seccomp-profile.json \
  midterm:version1
