<template>
  <div class="profile-page">
    <h1>{{ $t('profile') }}</h1>

    <form @submit.prevent="confirmUsernameUpdate" class="profile-form">
      <h2>{{ $t('changeUsername') }}</h2>
      <label for="username">{{ $t('username') }}</label>
      <input
          id="username"
          type="text"
          v-model="username"
          placeholder="username"
          required
      />
      <button type="submit">{{ $t('update') }}</button>
    </form>

    <form @submit.prevent="changePassword" class="profile-form">
      <h2>{{ $t('changePassword') }}</h2>
      <label for="password">{{ $t('password') }}</label>
      <input
          id="password"
          type="password"
          v-model="password"
          placeholder="password"
          required
      />
      <button type="submit">{{ $t('update') }}</button>
    </form>

    <div v-if="showConfirmModal" class="modal">
      <div class="modal-content">
        <p>{{ $t('usernameUpdateMessage') }}</p>
        <button @click="proceedWithUsernameUpdate">{{ $t('continue') }}</button>
        <button @click="cancelUsernameUpdate">{{ $t('cancel') }}</button>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref } from "vue";
import { UserRepository } from "~/infrastructure/repositories/UserRepository";
import { getUser, updatePassword, updateUsername } from "~/domain/use-cases/user";
import { useCookie, useRouter } from '#app'
import {CookiesEnum, RoutesEnum} from "~/config/constants";
import { useSnackbar } from "~/composables/useSnackBar";

const username = ref("")
const password = ref("")
const showConfirmModal = ref(false)
const router = useRouter()
const { showSnackbar } = useSnackbar()

onMounted(async () => {
  const userData = await user();
  if (userData) {
    username.value = userData['username'] || "";
  }
});

async function user() {
  try {
    return await new getUser(new UserRepository()).execute()
  } catch (error: any) {
    console.error(error.message)
    return null
  }
}

async function confirmUsernameUpdate() {
  if (!username.value) {
    return
  }
  showConfirmModal.value = true
}

async function proceedWithUsernameUpdate() {
  try {
    const response = await new updateUsername(new UserRepository()).execute(username.value)
    useCookie(CookiesEnum.TOKEN.toString()).value = null
    await router.push(RoutesEnum.LOGIN.toString())
    showSnackbar('logoutSuccess', 'success')
  } catch (error: any) {
    console.error(error.message)
  } finally {
    showConfirmModal.value = false
  }
}

function cancelUsernameUpdate() {
  showConfirmModal.value = false
}

async function changePassword() {
  if (!password.value) {
    return
  }
  try {
    return await new updatePassword(new UserRepository()).execute(password.value)
  } catch (error: any) {
    console.error(error.message)
  }
}
</script>

<style scoped lang="scss">
.profile-page {
  max-width: 600px;
  margin: 2rem auto;
  padding: 1rem;
  border-radius: 8px;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);

  h1 {
    text-align: center;
    margin-bottom: 2rem;
  }

  .profile-form {
    margin-bottom: 2rem;

    h2 {
      margin-bottom: 1rem;
    }

    label {
      display: block;
      margin-bottom: 0.5rem;
      font-weight: bold;
    }

    input {
      width: 100%;
      padding: 0.5rem;
      margin-bottom: 1rem;
      border: 1px solid #ccc;
      border-radius: 4px;
    }

    button {
      display: block;
      width: 100%;
      padding: 0.75rem;
      background-color: #007bff;
      color: #fff;
      border: none;
      border-radius: 4px;
      cursor: pointer;
      font-size: 1rem;
      transition: background-color 0.3s;

      &:hover {
        background-color: #0056b3;
      }
    }
  }
}

.modal {
  position: fixed;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  display: flex;
  align-items: center;
  justify-content: center;
  background: rgba(0, 0, 0, 0.5);

  .modal-content {
    background: #fff;
    padding: 2rem;
    border-radius: 8px;
    box-shadow: 0 2px 4px rgba(0, 0, 0, 0.2);
    text-align: center;

    button {
      margin: 0.5rem;
      padding: 0.75rem 1.5rem;
      border: none;
      border-radius: 4px;
      cursor: pointer;
      font-size: 1rem;
    }

    button:first-of-type {
      background-color: #007bff;
      color: #fff;
    }

    button:last-of-type {
      background-color: #ccc;
      color: #000;
    }
  }
}
</style>
