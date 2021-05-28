FROM ferrgo/curlybox:0.2.0

WORKDIR /home

COPY src/ /home

ENTRYPOINT [ "./notifier.sh" ]