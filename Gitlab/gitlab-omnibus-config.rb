external_url 'https://git.your-domain.com'
# Nginx config
nginx['listen_port'] = 80
nginx['listen_https'] = false
# SMTP
gitlab_rails['smtp_enable'] = false
gitlab_rails['smtp_address'] = "smtp.your-domain.com"
gitlab_rails['smtp_port'] = 25
gitlab_rails['smtp_domain'] = "your-domain.com"
gitlab_rails['gitlab_email_from'] = 'gitlab@your-domain.com'
gitlab_rails['gitlab_email_reply_to'] = 'gitlab@your-domain.com'
# Divers
puma['worker_processes'] = 1
sidekiq['max_concurrency'] = 5
prometheus_monitoring['enable'] = true