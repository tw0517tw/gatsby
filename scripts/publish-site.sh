echo "=== Building ES5 version of Gatsby"
rm -r node_modules yarn.lock
NODE_ENV=development yarn bootstrap
./node_modules/.bin/lerna run build

yarn global add gatsby-dev-cli
gatsby-dev --set-path-to-repo .

echo "=== Installing the website dependencies"
cd $1
# Normally you wouldn't do this but we
# want to test the latest versions of packages always
# so our example site builds catch problems early.
yarn

echo "=== Copying built Gatsby to website."
gatsby-dev --scan-once --quiet

cp ../../packages/gatsby-transformer-sharp/src/fragments.js node_modules/gatsby-transformer-sharp/src/fragments.js

echo "=== Building website"
# Once we get better cache invalidation, remove the following
# line.
rm -rf .cache

echo "temp delete offline-plugin gatsby-ssr.js"
rm ./node_modules/gatsby-plugin-offline/gatsby-ssr.js

NODE_ENV=production ./node_modules/.bin/gatsby build
