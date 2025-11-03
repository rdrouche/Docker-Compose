external_url 'https://git.your-domain.com'
# Nginx config
nginx['listen_port'] = 80
nginx['listen_https'] = false
# SMTP
gitlab_rails['smtp_enable'] = false
gitlab_rails['smtp_address'] = 'smtp.your-domain.com'
gitlab_rails['smtp_port'] = 25
gitlab_rails['smtp_domain'] = 'your-domain.com'
gitlab_rails['gitlab_email_from'] = 'gitlab@your-domain.com'
gitlab_rails['gitlab_email_reply_to'] = 'gitlab@your-domain.com'
# Divers
puma['worker_processes'] = 1
#sidekiq['max_concurrency'] = 5
prometheus_monitoring['enable'] = true
gitlab_exporter['enable'] = true

# Depot image Docker (registy)
#registry['enable'] = true
#registry_external_url 'https://registry.domain.tld'
#gitlab_rails['registry_enabled'] = true
#gitlab_rails['registry_path'] = '/var/opt/gitlab/gitlab-rails/shared/registry'
#registry_nginx['enable'] = true
#registry_nginx['ssl_certificate'] = '/etc/gitlab/registrydomaintld.crt'
#registry_nginx['ssl_certificate_key'] = '/etc/gitlab/registrydomaintld.key'

# SSO
#gitlab_rails['omniauth_auto_sign_in_with_provider'] = 'openid_connect'
#gitlab_rails['omniauth_block_auto_created_users'] = true

#SAML (ADFS)
#gitlab_rails['omniauth_allow_single_sign_on'] = ['saml']
#gitlab_rails['omniauth_auto_link_saml_user'] = true
#gitlab_rails['omniauth_providers'] = [{
#    name: 'saml',
#    label: 'SSO',
#    args: {
#        assertion_consumer_service_url: 'https://git.your-domain.com/users/auth/saml/callback',
#        idp_cert_fingerprint: '00:00:00:00:00:00:00',
#        idp_sso_target_url: 'https://adfs.domain.tld/adfs/ls',
#        issuer: 'https://git.your-domain.com',
#        name_identifier_format: 'urn:oasis:names:tc:SAML:1.1:nameid-format:unspecified'
#    }
#}]

#OPENID
#gitlab_rails['omniauth_allow_single_sign_on'] = ['openid_connect']
#gitlab_rails['omniauth_sync_email_from_provider'] = 'openid_connect'
#gitlab_rails['omniauth_sync_profile_from_provider'] = ['openid_connect']
#gitlab_rails['omniauth_sync_profile_attributes'] = ['email']
#gitlab_rails['omniauth_block_auto_created_users'] = false
#gitlab_rails['omniauth_auto_link_user'] = ['openid_connect']
#gitlab_rails['omniauth_providers'] = [{
#    name: 'openid_connect',
#    label: 'My Company OIDC Login',
#    args: {
#      name: 'openid_connect',
#      scope: ['openid','profile','email'],
#      response_type: 'code',
#      issuer: 'https://authentik.company/application/o/<application_slug>/',
#      discovery: true,
#      client_auth_method: 'query',
#      uid_field: 'preferred_username',
#      send_scope_to_token_endpoint: 'true',
#      pkce: true,
#      client_options: {
#        identifier: '${OIDC_CLIENT_ID}',
#        secret: '${OIDC_CLIENT_SECRET}',
#        redirect_uri: 'https://gitlab.company/users/auth/openid_connect/callback'
#      }
#    }
#}]