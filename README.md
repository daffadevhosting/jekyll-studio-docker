# Jekyll Studio Docker Container

Docker container dengan Ruby + Jekyll untuk Jekyll Studio webapp. Container ini menyediakan environment yang terisolasi dan konsisten untuk membuat, membangun, dan menyajikan situs Jekyll.

## 🚀 Quick Start

### 1. Clone dan Setup
```bash
git clone <repository-url>
cd jekyll-studio-docker
```

### 2. Build Container
```bash
make build
# atau
docker-compose build jekyll
```

### 3. Buat Situs Jekyll Baru
```bash
make create SITE_NAME=my-blog
# atau
docker-compose run --rm jekyll create my-blog
```

### 4. Jalankan Development Server
```bash
make serve SITE_NAME=my-blog
# atau
make serve SITE_NAME=my-blog PORT=4001
```

### 5. Akses Situs
- **Development**: http://localhost:4000
- **LiveReload**: Otomatis reload saat ada perubahan file

## 📁 Struktur Direktori

```
jekyll-studio-docker/
├── Dockerfile              # Jekyll container definition
├── docker-compose.yml      # Docker Compose configuration
├── entrypoint.sh           # Container entry script
├── nginx.conf              # Nginx proxy configuration
├── Makefile                # Command shortcuts
├── projects/               # Jekyll sites directory
│   └── my-blog/           # Individual Jekyll site
└── templates/              # Jekyll templates (optional)
```

## 🛠️ Available Commands

### Makefile Commands
```bash
make help           # Show all commands
make build          # Build Jekyll container
make up             # Start container
make down           # Stop container
make create         # Create new Jekyll site
make serve          # Serve Jekyll site
make build-site     # Build static site
make logs           # Show container logs
make shell          # Access container shell
make clean          # Clean up containers
```

### Docker Compose Commands
```bash
# Basic operations
docker-compose up -d jekyll
docker-compose down
docker-compose logs -f jekyll

# Jekyll operations
docker-compose run --rm jekyll create my-site
docker-compose run --rm jekyll serve /workspace/projects/my-site
docker-compose run --rm jekyll build /workspace/projects/my-site
```

### Direct Docker Commands
```bash
# Build image
docker build -t jekyll-studio .

# Run container
docker run -it --rm -p 4000:4000 -v $(pwd)/projects:/workspace/projects jekyll-studio

# Create new site
docker run --rm -v $(pwd)/projects:/workspace/projects jekyll-studio create my-site

# Serve existing site
docker run --rm -p 4000:4000 -v $(pwd)/projects:/workspace/projects jekyll-studio serve /workspace/projects/my-site
```

## 🔧 Configuration

### Environment Variables
- `JEKYLL_ENV`: Environment mode (development/production)
- `BUNDLE_PATH`: Bundler cache path
- `SITE_NAME`: Default site name for Makefile commands
- `PORT`: Development server port

### Volume Mounts
- `./projects`: Jekyll sites storage
- `./templates`: Jekyll templates (optional)
- `bundle_cache`: Gem cache untuk performa

### Ports
- `4000`: Jekyll development server
- `35729`: LiveReload server

## 🌐 Nginx Proxy (Optional)

Untuk menjalankan multiple sites atau production setup:

```bash
make proxy-up    # Start dengan nginx proxy
make proxy-down  # Stop proxy
```

### Proxy URLs:
- `http://localhost` - Static built sites
- `http://dev.localhost` - Development server
- `http://api.localhost` - API endpoints

## 💡 Usage Examples

### Untuk Jekyll Studio Webapp

1. **Buat Site dari AI Prompt**:
```bash
# Backend API call
POST /api/sites/create
{
  "name": "my-blog",
  "prompt": "Create a personal blog with dark theme"
}

# Container operation
docker-compose run --rm jekyll create my-blog
```

2. **Build dan Preview**:
```bash
# Build static site
docker-compose run --rm jekyll build /workspace/projects/my-blog

# Serve untuk preview
docker-compose run --rm -p 4000:4000 jekyll serve /workspace/projects/my-blog
```

3. **Live Development**:
```bash
# Start development server dengan live reload
make serve SITE_NAME=my-blog
```

### Integrasi dengan Backend API

```javascript
// Node.js example
const { exec } = require('child_process');

// Create new Jekyll site
function createSite(siteName) {
  return new Promise((resolve, reject) => {
    exec(`docker-compose run --rm jekyll create ${siteName}`, (error, stdout, stderr) => {
      if (error) reject(error);
      else resolve(stdout);
    });
  });
}

// Build site
function buildSite(siteName) {
  return new Promise((resolve, reject) => {
    exec(`docker-compose run --rm jekyll build /workspace/projects/${siteName}`, (error, stdout, stderr) => {
      if (error) reject(error);
      else resolve(stdout);
    });
  });
}
```

## 🔒 Security Features

- **Non-root user**: Container berjalan sebagai user `jekyll` (UID: 1000)
- **Isolated environment**: Setiap project terisolasi dalam container
- **Volume permissions**: Proper file permissions untuk mounted volumes
- **Alpine base**: Minimal attack surface dengan Alpine Linux

## 🚀 Production Deployment

### Build untuk Production
```bash
JEKYLL_ENV=production make build-site SITE_NAME=my-blog
```

### Docker Swarm/Kubernetes
Container sudah siap untuk deployment di orchestration platforms.

## 🧪 Development Tips

1. **Hot Reload**: File changes akan otomatis reload browser
2. **Bundle Cache**: Dependencies di-cache untuk build yang lebih cepat
3. **Multi-site**: Bisa menjalankan multiple Jekyll sites sekaligus
4. **Debug**: Gunakan `make logs` atau `make shell` untuk debugging

## 📚 Jekyll Features Included

- ✅ Jekyll 4.x terbaru
- ✅ Bundler untuk dependency management
- ✅ LiveReload untuk development
- ✅ Incremental builds
- ✅ Git support
- ✅ Node.js untuk asset processing
- ✅ Custom plugins support

## 🤝 Contributing

1. Fork repository
2. Buat feature branch
3. Test perubahan dengan `make build && make test`
4. Submit pull request

Container ini dirancang khusus untuk Jekyll Studio webapp dengan fokus pada:
- **Performance**: Fast builds dengan caching
- **Isolation**: Secure dan terisolasi
- **Scalability**: Bisa handle multiple sites
- **Developer Experience**: Easy commands dan debugging