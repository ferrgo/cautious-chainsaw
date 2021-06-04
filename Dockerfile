FROM ferrgo/curlybox

WORKDIR /home

COPY src/ /home

ENTRYPOINT [ "./notifier.sh" ]