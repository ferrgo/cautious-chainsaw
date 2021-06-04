FROM ferrgo/curlybox:0.2.1

WORKDIR /home

COPY src/ /home

ENTRYPOINT [ "./notifier.sh" ]