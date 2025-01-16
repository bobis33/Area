# Front Web

## Description

This is the web front-end for the area project. It is build with [Nuxt.js](https://nuxtjs.org/).

## Prerequisites

- [npm](https://www.npmjs.com/)

You will need to create a `.env` file in the `app/` folder and copy the content of the `.env.example` file in it. You will have to fill the variables with your own values.
In Production, you should change the value of the `API_URL` variable to the production API URL.

Make sure to install dependencies:

```bash
npm install
```

## Development Server

Start the development server on `http://localhost:8080`:

```bash
npm run dev
```

## Production

Build the application for production:

```bash
npm run build
```

Locally preview production build:

```bash
npm run preview
```
