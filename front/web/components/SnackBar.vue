<template>
  <div v-if="visible" class="snackbar" :class="type" @click="hideSnackbar">
    <span>{{ $t(message) }}</span>
  </div>
</template>

<script setup lang="ts">
import { ref, watch, onMounted } from 'vue'

const props = defineProps({
  message: {
    type: String,
    required: true,
  },
  type: {
    type: String,
    default: 'success',
  },
  duration: {
    type: Number,
    default: 3000,
  },
})

const visible = ref(false)

watch(() => props.message, (newMessage) => {
  if (newMessage) {
    visible.value = true
    setTimeout(() => {
      visible.value = false
    }, props.duration)
  }
})

const hideSnackbar = () => {
  visible.value = false
}

onMounted(() => {
  if (props.message) {
    visible.value = true
  }
})
</script>

<style scoped>
.snackbar {
  position: fixed;
  bottom: 30px;
  left: 50%;
  transform: translateX(-50%) translateY(100%);
  padding: 15px 30px;
  background: rgba(255, 255, 255, 0.9);
  color: #333;
  border-radius: 25px;
  font-size: 16px;
  font-weight: 500;
  z-index: 9999;
  box-shadow: 0px 8px 15px rgba(0, 0, 0, 0.2);
  backdrop-filter: blur(10px);
  transition: transform 0.5s ease, opacity 0.5s ease;
  opacity: 0;
  animation: slideIn 0.5s forwards;
  cursor: pointer;
}

.snackbar.success {
  background: linear-gradient(135deg, #d4edda, #c3e6cb);
  color: #155724;
}

.snackbar.error {
  background: linear-gradient(135deg, #f8d7da, #f5c6cb);
  color: #721c24;
}

.snackbar.warning {
  background: linear-gradient(135deg, #fff3cd, #ffeeba);
  color: #856404;
}

.snackbar:hover {
  transform: translateX(-50%) scale(1.05);
  box-shadow: 0px 12px 20px rgba(0, 0, 0, 0.25);
  opacity: 0.95;
}

@keyframes slideIn {
  from {
    opacity: 0;
    transform: translateX(-50%) translateY(100%);
  }
  to {
    opacity: 1;
    transform: translateX(-50%) translateY(0);
  }
}

.snackbar-leave-active {
  animation: slideOut 0.5s forwards;
}

@keyframes slideOut {
  from {
    opacity: 1;
    transform: translateX(-50%) translateY(0);
  }
  to {
    opacity: 0;
    transform: translateX(-50%) translateY(100%);
  }
}
</style>
