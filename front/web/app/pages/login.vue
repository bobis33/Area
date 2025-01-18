<template>
  <section :data-theme="$colorMode.preference" class="hero is-fullheight" :style="{ backgroundColor: 'var(--bg)' }">
    <div class="container">
      <div class="columns is-centered" style="padding-top: 5%;">
        <div class="column is-4 has-text-centered">
          <h1 class="title">{{ $t('login') }}</h1>

          <form @submit.prevent="handleSubmit" class="box" :style="{ backgroundColor: 'var(--bg-secondary)', boxShadow: '#00000077 0px 4px 8px'}">
            <div class="field">
              <label for="username" class="">{{ $t('username') }}</label>
              <div class="control">
                <input id="username" v-model="username" type="text" class="input" :placeholder="$t('username')" required />
              </div>
            </div>
            <div class="field">
              <label for="password" class="">{{ $t('password') }}</label>
              <div class="control">
                <input id="password" v-model="password" type="password" class="input" :placeholder="$t('password')" required />
              </div>
            </div>
            <div class="field">
              <div class="control">
                <button type="submit" class="button is-link is-fullwidth">{{ $t('login') }}</button>
              </div>
            </div>
          </form>

          <p v-if="errorMessage" class="notification is-danger">{{ $t(errorMessage) }}</p>
          <div class="buttons is-centered" style="width: 70%; margin: auto">
            <button class="button is-link is-fullwidth" @click="handleOAuth('discord')">
              <ImageComponent fileName="discord.png" altText="Discord logo" class="oauth-logo" />
              {{ $t('loginWithDiscord') }}
            </button>
            <button class="button is-link is-fullwidth" @click="handleOAuth('github')">
              <ImageComponent fileName="github.png" altText="GitHub logo" class="oauth-logo" />
              {{ $t('loginWithGithub') }}
            </button>
            <button class="button is-link is-fullwidth" @click="handleOAuth('google')">
              <ImageComponent fileName="google.png" altText="Google logo" class="oauth-logo" />
              {{ $t('loginWithGoogle') }}
            </button>
            <button class="button is-link is-fullwidth" @click="handleOAuth('microsoft')">
              <ImageComponent fileName="microsoft.png" altText="Microsoft logo" class="oauth-logo" />
              {{ $t('loginWithMicrosoft') }}
            </button>
          </div>

          <div class="has-text-centered mt-4">
            <p class="">{{ $t('noAccount') }}
              <a @click="router.push(RoutesEnum.REGISTER.toString())" class="is-text">{{ $t('registerHere') }}</a>
            </p>
          </div>
        </div>
      </div>
    </div>
  </section>
</template>

<script setup lang="ts">
import { ref, computed } from 'vue'
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

<style scoped>
@import "https://cdn.jsdelivr.net/npm/bulma@1.0.2/css/bulma.min.css";

.auth-logo {
  margin-bottom: 20px;
}

.oauth-logo {
  width: 20px;
  height: 20px;
  margin-right: 10px;
}

.notification {
  margin-top: 20px;
}

.buttons {
  margin-top: 20px;
}

.button.is-text {
  background: none;
  border: none;
  color: #3273dc;
  cursor: pointer;
  text-decoration: underline;
}
</style>