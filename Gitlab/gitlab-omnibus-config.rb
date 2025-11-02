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

#SAML (ADFS)
gitlab_rails['omniauth_allow_single_sign_on'] = ['saml']
gitlab_rails['omniauth_block_auto_created_users'] = true
gitlab_rails['omniauth_auto_link_saml_user'] = true
gitlab_rails['omniauth_providers'] = [{
    name: 'saml',
    label: 'SSO',
    args: {
        assertion_consumer_service_url: 'https://git.your-domain.com/users/auth/saml/callback',
        idp_cert_fingerprint: '00:00:00:00:00:00:00',
        idp_sso_target_url: 'https://adfs.domain.tld/adfs/ls',
        issuer: 'https://git.your-domain.com',
        name_identifier_format: 'urn:oasis:names:tc:SAML:1.1:nameid-format:unspecified'
    }
}]