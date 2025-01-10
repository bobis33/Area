<template>
  <div class="error-container">
    <h1 class="error-title">{{ $t('errorSomethingWentWrong') }}</h1>
    <p class="error-message-grey">
      <strong>{{ $t('errorCode') }}:</strong> {{ errorCode }} <br />
      <strong>{{ $t('errorCode') }}:</strong> {{ $t(errorMessage) }}
    </p>
    <router-link :to=RoutesEnum.LOGIN.toString() class="error-link">{{ $t('goBackHome') }}</router-link>
  </div>
</template>

<script setup lang="ts">
import {CookiesEnum, RoutesEnum} from '~/config/constants'

const error = useError()
const errorCode = error.value?.statusCode || 'unknownError'
const errorMessage = error.value?.statusMessage || 'anErrorOccurred'

const linkToGoogle = async (accessToken) => {
  const JWTToken = useCookie(CookiesEnum.TOKEN.toString()).value;
  try {
    const response = await fetch(`http://0.0.0.0:8080/auth/link/google?google_token=${accessToken}`, {
      method: 'POST',
      headers: {
        'Authorization': `Bearer ${JWTToken}`,
        'Content-Type': 'application/json',
      },
    })
  } catch (error) {
    console.error('There was a problem with the fetch operation:', error)
  }
}


if (window.location.search.includes('google_token')) {
  const token = window.location.search.split('google_token=')[1];
  const decodedToken = decodeURIComponent(token);

  console.log('decodedToken: ', decodedToken);
  const accessTokenMatch = decodedToken.match(/'access_token':\s*\+?'([^']+)'/);
  if (accessTokenMatch) {
    const accessToken = accessTokenMatch[1];
    console.log('Access Token:', accessToken);
    linkToGoogle(accessToken);
  }
}

</script>

<style scoped lang="scss">
@use 'assets/styles/errors' as *;
</style>
