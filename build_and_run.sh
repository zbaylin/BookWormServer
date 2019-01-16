cd "${0%/*}"
cd "src/reason-react"
npm run build &&
npm run webpack &&
cd "../.."
crystal run "src/BookWormServer.cr"
