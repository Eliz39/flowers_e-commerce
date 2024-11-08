# flowers_e-commerce

**Flower E-shop** is an online store built using [Medusa.js](https://medusajs.com) to offer a seamless shopping experience for flower products and accessories. This project includes a production database and deployment of all core components (admin, API, and frontend) on [Railway](https://railway.app/).

## Project Overview

Flower E-shop is designed to leverage Medusa.js for a modular and customizable backend. With a focus on simplicity and performance, this project aims to deliver a streamlined e-commerce experience.

### Key Technologies
- **Medusa.js** - Backend and e-commerce logic
- **Railway** - Hosting for production database and deployments
- **React** - Frontend framework
- **Notion** - Project documentation and wiki

## Project Structure

This repository contains three main components:
1. **Admin Dashboard** - Manage orders, products, and customers through a user-friendly interface.
2. **API** - Core backend powered by Medusa.js, providing RESTful services to the frontend.
3. **Frontend** - User interface built with React for a responsive shopping experience.

## Getting Started

To set up the project locally for development:

1. **Clone the repository**:
   ```bash
   git clone https://github.com/yourusername/flower-eshop.git
   cd flower-eshop



Here's an expanded **Getting Started** section for your README with additional setup instructions and details:

---

```markdown
## Getting Started

Follow these steps to set up the **Flower E-shop** locally for development.

### Prerequisites

Ensure you have the following installed on your system:
- **Node.js** (v16 or higher) - [Download Node.js](https://nodejs.org/)
- **Medusa CLI** - Install globally using:
  ```bash
  npm install -g @medusajs/medusa
  ```
- **Git** - For cloning the repository, if not already installed

### 1. Clone the Repository

Clone the Flower E-shop repository to your local machine:

```bash
git clone https://github.com/yourusername/flower-eshop.git
cd flower-eshop
```

### 2. Install Dependencies

In both project folder run, install all required dependencies:

```bash
npm install
```

run in storefront and backend


### Run services and both frontends

If you have not setup Postgres, continue step 3

Otherwise you can setup dev environment database_url from
https://railway.app/project/2d5882b8-6c95-4cdd-8ab7-6b9c40d8b35b/service/41863c45-dca7-4df7-81b5-0e3b22dd418c/data?state=table&table=user

```bash
npm run dev
```

This will install the packages for the backend, admin, and frontend components of the application.

### 3. Configure Environment Variables

Create a `.env` file at the root of the project. This file will store environment variables needed for connecting to the database, configuring API endpoints, and managing deployments.

Here’s a basic `.env` template:

```plaintext
# Medusa server variables
MEDUSA_ADMIN_URL=http://localhost:7000
MEDUSA_API_URL=http://localhost:9000

# Database URL for local development (PostgreSQL recommended)
DATABASE_URL=postgresql://<username>:<password>@localhost:5432/flower_eshop

# Optional: Railway configuration if deploying
RAILWAY_ENVIRONMENT=development
```

> **Note**: Replace `<username>` and `<password>` with your actual database credentials.

For the production environment, these variables will be managed by Railway. The database URL and other sensitive credentials should be securely stored in your production environment on Railway.

### 4. Set Up the Database

If you're running a PostgreSQL database locally, create a new database named `flower_eshop` (or update the database name in the `.env` file as needed).

You can create a database with the following command:

```bash
createdb flower_eshop
```

Once the database is ready, you can run migrations to set up the initial schema:

```bash
medusa migrations run
```

### 5. Seed the Database (Optional)

To populate the database with sample products, run the following command:

```bash
medusa seed -f ./data/seed.json
```

This will load sample products into your database, allowing you to test the app with pre-existing data.

### 6. Run the Application

Now you can start each component of the Flower E-shop locally.

#### Start the Backend (API)

In the project root, run:

```bash
medusa develop
```

This starts the Medusa API server on [http://localhost:9000](http://localhost:9000).



### 7. Accessing the Application

With all services running, you can now access the various parts of the Flower E-shop:
- **Frontend** (Customer site): [http://localhost:8000](http://localhost:9001)
- **Admin Dashboard**: [http://localhost:7000](http://localhost:9000/app)
- **API Server**: [http://localhost:9000](http://localhost:9000)

### Troubleshooting

- **Database connection issues**: Double-check the `DATABASE_URL` in your `.env` file and ensure the PostgreSQL server is running.
- **Ports in use**: If you encounter "port already in use" errors, make sure no other applications are running on the same ports (7000, 8000, 9000).

Now you’re ready to develop and test Flower E-shop locally!

```