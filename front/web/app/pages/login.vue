<template>
  <div class="form-container">
    <ImageComponent fileName="area.png" altText="area" class="auth-logo" />
    <h1 class="form-title">{{ $t('login') }}</h1>

    <form @submit.prevent="handleSubmit">
      <div class="mb-4">
        <label for="username" class="label">{{ $t('username') }}</label>
        <input id="username" v-model="username" type="text" class="input-field" :placeholder="$t('username')" />
      </div>
      <div class="mb-4">
        <label for="password" class="label">{{ $t('password') }}</label>
        <input id="password" v-model="password" type="password" class="input-field" :placeholder="$t('password')" />
      </div>
      <button type="submit" class="btn-primary w-full mt-8">{{ $t('login') }}</button>
    </form>

    <p v-if="errorMessage" class="error-message">{{ $t(errorMessage) }}</p>

    <div class="separator">
    </div>
    <div class="oauth-buttons">
      <button class="btn-oauth discord" @click="handleOAuth('discord')">
        <ImageComponent fileName="discord.png" altText="Discord logo" class="oauth-logo" />
        {{ $t('loginWithDiscord') }}
      </button>
      <button class="btn-oauth github" @click="handleOAuth('github')">
        <ImageComponent fileName="github.png" altText="GitHub logo" class="oauth-logo" />
        {{ $t('loginWithGithub') }}
      </button>
      <button class="btn-oauth google" @click="handleOAuth('google')">
        <ImageComponent fileName="google.png" altText="Google logo" class="oauth-logo" />
        {{ $t('loginWithGoogle') }}
      </button>
      <button class="btn-oauth microsoft" @click="handleOAuth('microsoft')">
        <ImageComponent fileName="microsoft.png" altText="Microsoft logo" class="oauth-logo" />
        {{ $t('loginWithMicrosoft') }}
      </button>
    </div>

    <div class="text-link mt-4">
      <p>{{ $t('noAccount') }}
        <button @click="router.push(RoutesEnum.REGISTER.toString())" class="btn-link">{{ $t('registerHere') }}</button>
      </p>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref } from 'vue'
import { useCookie, useRouter } from '#app'
import ImageComponent from '~/components/Assets.vue'

import { useSnackbar } from '~/composables/useSnackBar'
import { LoginUser } from '~/domain/use-cases/auth'
import { CookiesEnum, RoutesEnum } from '~/config/constants'
import { AuthRepository } from '~/infrastructure/repositories/AuthRepository'

const username = ref('')
const password = ref('')
const errorMessage = ref('')
const tokenCookie = useCookie(CookiesEnum.TOKEN.toString(), { path: '/', maxAge: 60 * 60 * 24 * 7 })
const router = useRouter()
const { showSnackbar } = useSnackbar()

async function handleSubmit() {
  try {
    if (!username.value || !password.value) {
      errorMessage.value = 'fillInAllFields'
      return
    }
    tokenCookie.value = await new LoginUser(new AuthRepository()).execute({ username: username.value, password: password.value })
    showSnackbar('loginSuccess', 'success')
    await router.push(RoutesEnum.AREAS.toString())
  } catch (error: any) {
    errorMessage.value = error.message
  }
}

function handleOAuth(provider: 'discord' | 'github' | 'google' | 'microsoft') {
  const apiUrl = useRuntimeConfig().public.baseUrlApi
  const oauthUrls = {
    discord: `${apiUrl}/auth/login/with/discord`,
    github: `${apiUrl}/auth/login/with/github`,
    google: `${apiUrl}/auth/login/with/google`,
    microsoft: `${apiUrl}/auth/login/with/microsoft`,
  }

  if (oauthUrls[provider]) {
    window.location.href = oauthUrls[provider]
  }
}
</script>

<style scoped lang="scss">
@use 'assets/styles/buttons' as *;
@use 'assets/styles/errors' as *;
@use 'assets/styles/forms' as *;
@use 'assets/styles/logo' as *;

.oauth-buttons {
  display: flex;
  flex-direction: column;
  gap: 1rem;

  .btn-oauth {
    display: flex;
    align-items: center;
    justify-content: center;
    padding: 0.75rem 1rem;
    border: none;
    border-radius: 5px;
    cursor: pointer;
    font-weight: bold;
    font-size: 1rem;
    color: white;

    &.discord {
      background-color: #858585;
    }

    &.github {
      background-color: #858585;
    }

    &.google {
      background-color: #858585;
    }

    &.microsoft {
      background-color: #858585;
    }

    .oauth-logo {
      width: 20px;
      height: 20px;
      margin-right: 0.5rem;
    }
  }
}

.separator {
  margin: 1rem 0;
  color: #aaa;

  span {
    background-color: white;
    padding: 0 0.5rem;
  }
}

</style>
