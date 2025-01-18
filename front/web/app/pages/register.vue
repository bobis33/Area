<template>
  <section :data-theme="$colorMode.preference" class="hero is-fullheight" :style="{ backgroundColor: 'var(--bg)' }">
    <div class="container">
      <div class="columns is-centered" style="padding-top: 5%;">
        <div class="column is-4">
          <nuxt-link to="/settings" class="link-button" :style="{color: 'var(--text-color)'}">
            <img src="@/assets/icons/settings.png" :alt="$t('settings')" style="width: 30px; height: 30px; margin: 3px;" :style="{filter: 'var(--filter)'}"/>
          </nuxt-link>
        </div>
        <div class="column is-4 has-text-centered">
          <h1 class="title">{{ $t('register') }}</h1>

          <form @submit.prevent="handleRegister" class="box" :style="{ backgroundColor: 'var(--bg-secondary)', boxShadow: '#00000077 0px 4px 8px'}">
            <div class="field">
              <label for="username" class="label">{{ $t('username') }}</label>
              <div class="control">
                <input id="username" v-model="username" type="text" class="input" :placeholder="$t('username')" required />
              </div>
            </div>
            <div class="field">
              <label for="password" class="label">{{ $t('password') }}</label>
              <div class="control">
                <input id="password" v-model="password" type="password" class="input" :placeholder="$t('password')" required />
              </div>
            </div>
            <div class="field">
              <label for="confirmPassword" class="label">{{ $t('passwordConfirmation') }}</label>
              <div class="control">
                <input id="confirmPassword" v-model="confirmPassword" type="password" class="input" :placeholder="$t('passwordConfirmation')" required />
              </div>
            </div>
            <div class="field">
              <div class="control">
                <button type="submit" class="button is-link is-fullwidth" :aria-label="$t('register')">{{ $t('register') }}</button>
              </div>
            </div>
          </form>

          <p v-if="errorMessage" class="notification is-danger">{{ $t(errorMessage) }}</p>

          <div class="has-text-centered mt-4">
            <p class="">{{ $t('alreadyHaveAccount') }}
              <button @click="router.push(RoutesEnum.LOGIN.toString())" class="has-text-primary">{{ $t('loginHere') }}</button>
            </p>
          </div>
        </div>
        <div class="column is-4"></div>
      </div>
    </div>
  </section>
</template>


<script setup lang="ts">
import { ref } from 'vue'
import { useRouter } from '#app'

import { useSnackbar } from '~/composables/useSnackBar'
import { RoutesEnum } from '~/config/constants'
import { AuthRepository } from '~/infrastructure/repositories/AuthRepository'
import { RegisterUser } from '~/domain/use-cases/auth'
import ImageComponent from "~/components/Assets.vue";

const username = ref('')
const password = ref('')
const confirmPassword = ref('')
const errorMessage = ref('')
const router = useRouter()
const { showSnackbar } = useSnackbar()

const handleRegister = async () => {
  try {
    if (!username.value || !password.value || !confirmPassword.value) {
      errorMessage.value = 'fillInAllFields'
      return
    }
    if (password.value !== confirmPassword.value) {
      errorMessage.value = 'passwordMismatch'
      return
    }

    const token = await new RegisterUser(new AuthRepository()).execute({ username: username.value, password: password.value })
    if (token) {
      showSnackbar('registerSuccess', 'success')
      await router.push(RoutesEnum.LOGIN.toString());
    }
  } catch (error: any) {
    errorMessage.value = error.message || 'anErrorOccurred'
  }
}
</script>

<style scoped lang="scss">
@use 'assets/styles/buttons' as *;
@use 'assets/styles/errors' as *;
@use 'assets/styles/forms' as *;
@use 'assets/styles/logo' as *;

@import "https://cdn.jsdelivr.net/npm/bulma@1.0.2/css/bulma.min.css";
</style>
