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
import { CookiesEnum, RoutesEnum } from '~/config/constants'
import { LinkToGoogle } from "~/domain/use-cases/oauth";
import { OauthRepository } from "~/infrastructure/repositories/OauthRepository";

const error = useError()
const errorCode = error.value?.statusCode || 'unknownError'
const errorMessage = error.value?.statusMessage || 'anErrorOccurred'

const linkToGoogle = async (accessToken: string) => {
  try {
    await new LinkToGoogle(new OauthRepository()).execute(useCookie(CookiesEnum.TOKEN.toString()).value!, accessToken);
  } catch (error) {
    console.error('Error linking to Google:', error);
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
  window.location.href = RoutesEnum.PROFILE.toString();
}

</script>

<style scoped lang="scss">
@use 'assets/styles/errors' as *;
</style>
