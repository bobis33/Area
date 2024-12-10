<template>
  <div>
    <h1>Authenticating...</h1>
  </div>
</template>

<script setup>
import { useCookie } from '#app'

import { CookiesEnum } from "~/constants";

const params = new URLSearchParams(window.location.search)
const oauthTokenCookie = useCookie(CookiesEnum.OAUTHTOKEN.toString())
const token = params.get('token')
const error = params.get('error')

if (token) {
  console.log("Token received:", token)

  oauthTokenCookie.value = token

} else if (error) {
  console.error("OAuth failed:", error)

  alert("Login failed. Please try again.")
} else {
  console.log("No token or error found in the URL.")
}
</script>

<style scoped>
</style>