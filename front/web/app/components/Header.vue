<template>
  <header class="header">
    <div class="burger-container">
      <button
          class="burger-menu"
          @click="toggleMenu"
          :aria-expanded="isMenuOpen"
          aria-label="Toggle menu"
      >
        <span></span>
        <span></span>
        <span></span>
      </button>
    </div>

    <nav :class="{ open: isMenuOpen }">
      <ul class="pt-10">
        <li
            v-for="item in filteredMenuItems"
            :key="item.path"
        >
          <a
              :href="item.path"
              :class="{ active: isActive(item.path) }"
          >
            {{ $t(item.label) }}
          </a>
        </li>
      </ul>
      <LanguageSwitcher />
      <ThemeSwitcher />
    </nav>
  </header>
</template>

<script setup lang="ts">
import { ref } from 'vue'
import { useRoute } from 'vue-router'
import {CookiesEnum, RoutesEnum} from "~/config/constants";
import { useCookie } from "#app";
import { VerifyToken } from "~/domain/use-cases/auth";
import { AuthRepository } from "~/infrastructure/repositories/AuthRepository";

const route = useRoute()
const isMenuOpen = ref(false)
const token = useCookie(CookiesEnum.TOKEN.toString()).value
const response = token ? await new VerifyToken(new AuthRepository()).execute(token) : false
const toggleMenu = () => { isMenuOpen.value = !isMenuOpen.value }
const isActive = (path: string) => route.path === path
const menuItems = [
  { path: RoutesEnum.HOME.toString(), label: 'home' },
  { path: RoutesEnum.AREAS.toString(), label: 'myAreas' },
  { path: RoutesEnum.LOGIN.toString(), label: 'login' },
  { path: RoutesEnum.PROFILE.toString(), label: 'profile' },
  { path: RoutesEnum.REGISTER.toString(), label: 'register' },
]
const filteredMenuItems = computed(() => {
  if (response) {
    return menuItems.filter((item) => item.path !== RoutesEnum.LOGIN.toString() && item.path !== RoutesEnum.REGISTER.toString())
  } else {
    return menuItems.filter((item) => item.path !== RoutesEnum.HOME.toString() && item.path !== RoutesEnum.AREAS.toString() && item.path !== RoutesEnum.PROFILE.toString())
  }
})

watch(
    () => route.path,
    () => { location.reload() }
)
</script>

<style scoped lang="scss">
.header {
  display: flex;
  justify-content: flex-end;
  align-items: center;
  padding: 1rem;

  .burger-container {
    display: flex;
    align-items: center;
  }

  .burger-menu {
    width: 30px;
    height: 20px;
    display: flex;
    flex-direction: column;
    justify-content: space-between;
    z-index: 15;

    span {
      width: 100%;
      height: 3px;
      background: var(--text-color);
      transition: transform 0.3s, opacity 0.3s;
    }
  }

  nav {
    position: fixed;
    top: 0;
    right: 0;
    height: 100%;
    width: 15%;
    transform: translateX(100%);
    transition: transform 0.4s ease-in-out;
    padding: 1rem;
    box-shadow: -2px 0 6px rgba(0, 0, 0, 0.1);

    &.open {
      transform: translateX(0);
    }

    ul {
      display: flex;
      flex-direction: column;
      gap: 1rem;

      li a {
        color: var(--text-color);
        font-weight: bold;
        transition: color 0.3s;

        &:hover, &.active {
          color: var(--color-primary);
        }
      }
    }
  }
}
</style>
