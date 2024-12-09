<template>
  <div>
    <h1>Authenticating...</h1>
  </div>
</template>

<script setup>
import { useRouter, useCookie } from '#app'

const router = useRouter()
const tokenCookie = useCookie('token')

// Capture the token from the URL
const params = new URLSearchParams(window.location.search)
const token = params.get('token')
const error = params.get('error')

// Handle the response
if (token) {
  console.log("Token received:", token)

  // Save the token securely (e.g., in a cookie or localStorage)
  tokenCookie.value = token

  // Optionally, navigate the user to a logged-in page
  router.push('/dashboard') // Adjust as needed
} else if (error) {
  console.error("OAuth failed:", error)

  // Optionally, show an error message to the user
  alert("Login failed. Please try again.")
} else {
  console.log("No token or error found in the URL.")
}
</script>

<style scoped>
/* Add your styles here */
</style>