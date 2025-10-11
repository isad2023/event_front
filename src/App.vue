<script setup lang="ts">
import { RouterView, useRouter, useRoute } from 'vue-router'
import { computed } from 'vue'

const router = useRouter()
const route = useRoute()

const isCoworking = computed(() => route.path === '/coworking')
const isHome = computed(() => route.path === '/')
const isEventDetail = computed(() => route.path.startsWith('/event/'))
</script>

<template>
  <div id="app">
    <nav v-if="!isEventDetail" class="main-nav">
      <div class="nav-container">
        <button
          @click="router.push('/')"
          :class="['nav-btn', { active: isHome }]"
        >
          Мероприятия
        </button>
        <button
          @click="router.push('/coworking')"
          :class="['nav-btn', { active: isCoworking }]"
        >
          Коворкинг
        </button>
      </div>
    </nav>
    <RouterView />
  </div>
</template>

<style scoped>
#app {
  min-height: 100vh;
  background: linear-gradient(135deg, #1a1a1a 0%, #2d2d2d 100%);
}

.main-nav {
  position: sticky;
  top: 0;
  z-index: 100;
  background: rgba(0, 0, 0, 0.5);
  backdrop-filter: blur(10px);
  border-bottom: 1px solid rgba(255, 255, 255, 0.1);
}

.nav-container {
  max-width: 1200px;
  margin: 0 auto;
  padding: 1rem 2rem;
  display: flex;
  gap: 1rem;
}

.nav-btn {
  background: rgba(255, 255, 255, 0.05);
  color: rgba(255, 255, 255, 0.7);
  border: 1px solid rgba(255, 255, 255, 0.1);
  border-radius: 12px;
  padding: 0.75rem 1.5rem;
  font-size: 1rem;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.3s ease;
}

.nav-btn:hover {
  background: rgba(255, 255, 255, 0.1);
  color: white;
  transform: translateY(-1px);
}

.nav-btn.active {
  background: linear-gradient(135deg, #8b5cf6, #d946ef);
  color: white;
  border-color: transparent;
  box-shadow: 0 4px 12px rgba(139, 92, 246, 0.3);
}

@media (max-width: 768px) {
  .nav-container {
    padding: 1rem;
  }

  .nav-btn {
    flex: 1;
    text-align: center;
  }
}
</style>