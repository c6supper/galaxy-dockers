
# Use Rocket.Chat official image
FROM rocket.chat:3.7.1

MAINTAINER calvin <c6supper@hotmail.com>

USER root

ENV GALAXY_DIR /galaxy
ENV GALAXY_INITIALIZED_MARK $GALAXY_DIR/patched
RUN mkdir -p $GALAXY_DIR
COPY ./version $GALAXY_DIR/version
COPY ./docker-entrypoint.sh $GALAXY_DIR/docker-entrypoint.sh
ARG LIVENESS_PROBE
ENV GALAXY_MONGO_HOST galaxy-mongo
ENV GALAXY_MONGO_PORT 27017

RUN echo "$LIVENESS_PROBE" > $GALAXY_DIR/liveness_probe.sh && \
    chmod a+x $GALAXY_DIR/liveness_probe.sh && \
    chown -R rocketchat:rocketchat $GALAXY_DIR

USER rocketchat

ENV APP_SERVER_ROOT_URL ezremote.veexinc.net
ENV ROCKETCHAT_ROOT_URL https://$APP_SERVER_ROOT_URL
ENV Accounts_OAuth_Custom-Keycloak true
ENV Accounts_OAuth_Custom-Keycloak-url $ROCKETCHAT_ROOT_URL/keycloak/auth
ENV Accounts_OAuth_Custom-Keycloak-token_path /realms/VeEX/protocol/openid-connect/token
ENV Accounts_OAuth_Custom-Keycloak-token_sent_via header
ENV Accounts_OAuth_Custom-Keycloak-identity_token_sent_via header
ENV Accounts_OAuth_Custom-Keycloak-identity_path /realms/VeEX/protocol/openid-connect/userinfo
ENV Accounts_OAuth_Custom-Keycloak-authorize_path /realms/VeEX/protocol/openid-connect/auth
ENV Accounts_OAuth_Custom-Keycloak-scope openid
ENV Accounts_OAuth_Custom-Keycloak-id EZRemote
ENV Accounts_OAuth_Custom-Keycloak-login_style redirect
ENV Accounts_OAuth_Custom-Keycloak-button_label_text Login via Keycloak
ENV Accounts_OAuth_Custom-Keycloak-button_label_color "#FFFFFF"
ENV Accounts_OAuth_Custom-Keycloak-button_color "#13679A"
ENV Accounts_OAuth_Custom-Keycloak-username_field preferred_username
ENV Accounts_OAuth_Custom-Keycloak-merge_users true
ENV Accounts_OAuth_Custom-Keycloak-access_token_param access_token
ENV Iframe_Integration_send_enable true
ENV Iframe_Integration_receive_enable true

# initilization for the first time
ENTRYPOINT ["/galaxy/docker-entrypoint.sh"]