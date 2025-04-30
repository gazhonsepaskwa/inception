#!/bin/bash
set -e

echo "Waiting for MySQL to be ready..."
until wp db check --allow-root; do
  sleep 2
done

chown -R www-data:www-data /var/www/html

if ! wp core is-installed --allow-root; then
  wp core install \
    --url="http://localhost" \
    --title="A site" \
    --admin_user="$WORDPRESS_ADMIN_USER" \
    --admin_password="$WORDPRESS_ADMIN_PASSWORD" \
    --admin_email="$WORDPRESS_ADMIN_EMAIL" \
    --skip-email \
    --allow-root
fi

# --- basic homepage if it doesn't exist ---
HOMEPAGE_ID=$(wp post list --post_type=page --pagename=home --field=ID --allow-root)

if [ -z "$HOMEPAGE_ID" ]; then
  HOMEPAGE_ID=$(wp post create \
    --post_type=page \
    --post_title="Home" \
    --post_name="home" \
    --post_status=publish \
    --porcelain \
    --allow-root)
fi

# Set the static homepage
wp option update show_on_front 'page' --allow-root
wp option update page_on_front $HOMEPAGE_ID --allow-root

exec "$@"
