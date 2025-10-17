<script setup lang="ts">
import { ref, computed } from 'vue'
import Navigation from './Navigation.vue'

interface DonationItem {
  name: string
  contribution: string
  amount?: number
  items?: string[]
}

const days = ['Пн', 'Вт', 'Ср', 'Чт', 'Пт', 'Сб', 'Вс']
const selectedDay = ref(5)

const status = ref<'open' | 'closed'>('open')
const keyHolder = ref('Иван Иванов (@ivanov)')

const showKeyTransferModal = ref(false)
const showStatusModal = ref(false)

const keyTransferForm = ref({
  studentId: '',
  fromTelegram: '',
  toTelegram: ''
})

const weekdayOccupancy = [
  { hour: '00:00', level: 0 },
  { hour: '01:00', level: 0 },
  { hour: '02:00', level: 0 },
  { hour: '03:00', level: 0 },
  { hour: '04:00', level: 0 },
  { hour: '05:00', level: 0 },
  { hour: '06:00', level: 0 },
  { hour: '07:00', level: 0 },
  { hour: '08:00', level: 5 },
  { hour: '09:00', level: 15 },
  { hour: '10:00', level: 25 },
  { hour: '11:00', level: 40 },
  { hour: '12:00', level: 55 },
  { hour: '13:00', level: 70 },
  { hour: '14:00', level: 85 },
  { hour: '15:00', level: 75 },
  { hour: '16:00', level: 60 },
  { hour: '17:00', level: 45 },
  { hour: '18:00', level: 35 },
  { hour: '19:00', level: 25 },
  { hour: '20:00', level: 15 },
  { hour: '21:00', level: 10 },
  { hour: '22:00', level: 5 },
  { hour: '23:00', level: 0 }
]

const fridayOccupancy = [
  { hour: '00:00', level: 0 },
  { hour: '01:00', level: 0 },
  { hour: '02:00', level: 0 },
  { hour: '03:00', level: 0 },
  { hour: '04:00', level: 0 },
  { hour: '05:00', level: 0 },
  { hour: '06:00', level: 0 },
  { hour: '07:00', level: 0 },
  { hour: '08:00', level: 5 },
  { hour: '09:00', level: 15 },
  { hour: '10:00', level: 25 },
  { hour: '11:00', level: 40 },
  { hour: '12:00', level: 55 },
  { hour: '13:00', level: 60 },
  { hour: '14:00', level: 45 },
  { hour: '15:00', level: 30 },
  { hour: '16:00', level: 20 },
  { hour: '17:00', level: 10 },
  { hour: '18:00', level: 5 },
  { hour: '19:00', level: 0 },
  { hour: '20:00', level: 0 },
  { hour: '21:00', level: 0 },
  { hour: '22:00', level: 0 },
  { hour: '23:00', level: 0 }
]

const weekendOccupancy = [
  { hour: '00:00', level: 0 },
  { hour: '01:00', level: 0 },
  { hour: '02:00', level: 0 },
  { hour: '03:00', level: 0 },
  { hour: '04:00', level: 0 },
  { hour: '05:00', level: 0 },
  { hour: '06:00', level: 0 },
  { hour: '07:00', level: 0 },
  { hour: '08:00', level: 0 },
  { hour: '09:00', level: 0 },
  { hour: '10:00', level: 0 },
  { hour: '11:00', level: 0 },
  { hour: '12:00', level: 0 },
  { hour: '13:00', level: 0 },
  { hour: '14:00', level: 0 },
  { hour: '15:00', level: 0 },
  { hour: '16:00', level: 0 },
  { hour: '17:00', level: 0 },
  { hour: '18:00', level: 0 },
  { hour: '19:00', level: 0 },
  { hour: '20:00', level: 0 },
  { hour: '21:00', level: 0 },
  { hour: '22:00', level: 0 },
  { hour: '23:00', level: 0 }
]

const hourlyOccupancy = computed(() => {
  if (selectedDay.value === 4) {
    return fridayOccupancy
  }
  if (selectedDay.value === 5 || selectedDay.value === 6) {
    return weekendOccupancy
  }
  return weekdayOccupancy
})

const donors = ref<DonationItem[]>([
  { name: 'Алексей Петров', contribution: 'Холодильник Samsung', items: ['Холодильник Samsung'] },
  { name: 'Мария Смирнова', contribution: '15,000 ₽', amount: 15000 },
  { name: 'Дмитрий Козлов', contribution: '10,000 ₽', amount: 10000 },
  { name: 'Елена Волкова', contribution: 'USB-C переходники (5 шт)', items: ['USB-C переходники (5 шт)'] },
  { name: 'Сергей Новиков', contribution: '8,500 ₽', amount: 8500 },
  { name: 'Анна Федорова', contribution: 'Настольная лампа IKEA', items: ['Настольная лампа IKEA'] },
  { name: 'Игорь Морозов', contribution: '7,000 ₽', amount: 7000 },
])

const currentHour = new Date().getHours()
const currentOccupancy = computed(() => {
  const current = hourlyOccupancy.value[currentHour]
  if (current.level < 30) return 'Низкая загруженность'
  if (current.level < 70) return 'Средняя загруженность'
  return 'Высокая загруженность'
})

const currentOccupancyClass = computed(() => {
  const current = hourlyOccupancy.value[currentHour]
  if (current.level < 30) return 'low'
  if (current.level < 70) return 'medium'
  return 'high'
})

const maxLevel = computed(() => {
  const max = Math.max(...hourlyOccupancy.value.map(h => h.level))
  return max === 0 ? 1 : max
})

const handleKeyTransfer = () => {
  keyHolder.value = `${keyTransferForm.value.toTelegram}`

  keyTransferForm.value = {
    studentId: '',
    fromTelegram: '',
    toTelegram: ''
  }

  showKeyTransferModal.value = false
}

const updateStatus = (newStatus: 'open' | 'closed') => {
  status.value = newStatus
  showStatusModal.value = false
}
</script>

<template>
  <div class="coworking-page">
    <div class="page-header">
      <div class="container">
        <Navigation />
      </div>
    </div>

    <div class="container">
      <div class="top-section">
        <div class="status-card">
          <div class="status-header">
            <h2>Статус коворкинга</h2>
            <button @click="showStatusModal = true" class="edit-status-btn">
              Изменить статус
            </button>
          </div>
          <div class="status-content">
            <div :class="['status-indicator', status]">
              <span class="status-dot"></span>
              {{ status === 'open' ? 'Открыт' : 'Закрыт' }}
            </div>
            <div class="key-holder">
              <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                <path d="M21 2l-2 2m-7.61 7.61a5.5 5.5 0 1 1-7.778 7.778 5.5 5.5 0 0 1 7.777-7.777zm0 0L15.5 7.5m0 0l3 3L22 7l-3-3m-3.5 3.5L19 4"/>
              </svg>
              Ответственный: {{ keyHolder }}
            </div>
            <button @click="showKeyTransferModal = true" class="transfer-btn">
              Передать ключи
            </button>
          </div>
        </div>

        <div class="occupancy-card">
          <h2>Посещаемость коворкинга</h2>

          <div :class="['current-status', currentOccupancyClass]">
            <div class="current-time">{{ currentHour }}:00</div>
            <div class="current-label">{{ currentOccupancy }}</div>
          </div>

          <div class="days-selector">
            <button
              v-for="(day, index) in days"
              :key="index"
              @click="selectedDay = index"
              :class="['day-btn', { active: selectedDay === index }]"
            >
              {{ day }}
            </button>
          </div>

          <div class="chart">
            <div class="chart-bars">
              <div
                v-for="(item, index) in hourlyOccupancy"
                :key="index"
                class="bar-wrapper"
              >
                <div
                  class="bar"
                  :style="{ height: `${(item.level / maxLevel) * 100}%` }"
                  :class="{ current: index === currentHour }"
                ></div>
              </div>
            </div>
            <div class="chart-labels">
              <span>00:00</span>
              <span>04:00</span>
              <span>08:00</span>
              <span>12:00</span>
              <span>16:00</span>
              <span>20:00</span>
              <span>00:00</span>
            </div>
          </div>
        </div>
      </div>

      <div class="donors-section">
        <div class="donors-card">
          <h2>Рейтинг донатящих</h2>
          <div class="donors-list">
            <div v-for="(donor, index) in donors" :key="index" class="donor-item">
              <div class="donor-rank">{{ index + 1 }}</div>
              <div class="donor-info">
                <div class="donor-name">{{ donor.name }}</div>
                <div class="donor-contribution">{{ donor.contribution }}</div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>

    <div v-if="showKeyTransferModal" class="modal-overlay" @click.self="showKeyTransferModal = false">
      <div class="modal">
        <div class="modal-header">
          <h3>Передача ключей</h3>
          <button @click="showKeyTransferModal = false" class="close-btn">
            <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
              <line x1="18" y1="6" x2="6" y2="18"/>
              <line x1="6" y1="6" x2="18" y2="18"/>
            </svg>
          </button>
        </div>
        <form @submit.prevent="handleKeyTransfer" class="modal-form">
          <div class="form-group">
            <label>Номер студенческого билета</label>
            <input
              v-model="keyTransferForm.studentId"
              type="text"
              placeholder="Введите номер"
              required
            />
          </div>
          <div class="form-group">
            <label>Ваш тег в Telegram</label>
            <input
              v-model="keyTransferForm.fromTelegram"
              type="text"
              placeholder="@username"
              required
            />
          </div>
          <div class="form-group">
            <label>Тег получателя в Telegram</label>
            <input
              v-model="keyTransferForm.toTelegram"
              type="text"
              placeholder="@username"
              required
            />
          </div>
          <button type="submit" class="submit-btn">
            Передать ключи
          </button>
        </form>
      </div>
    </div>

    <div v-if="showStatusModal" class="modal-overlay" @click.self="showStatusModal = false">
      <div class="modal">
        <div class="modal-header">
          <h3>Изменить статус коворкинга</h3>
          <button @click="showStatusModal = false" class="close-btn">
            <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
              <line x1="18" y1="6" x2="6" y2="18"/>
              <line x1="6" y1="6" x2="18" y2="18"/>
            </svg>
          </button>
        </div>
        <div class="status-options">
          <button @click="updateStatus('open')" class="status-option open">
            <span class="status-dot"></span>
            Открыть коворкинг
          </button>
          <button @click="updateStatus('closed')" class="status-option closed">
            <span class="status-dot"></span>
            Закрыть коворкинг
          </button>
        </div>
      </div>
    </div>
  </div>
</template>

<style scoped>
.coworking-page {
  min-height: 100vh;
  background: linear-gradient(135deg, #1a1a1a 0%, #2d2d2d 100%);
  color: white;
  padding-bottom: 3rem;
}

.page-header {
  background: rgba(0, 0, 0, 0.3);
  backdrop-filter: blur(10px);
  border-bottom: 1px solid rgba(255, 255, 255, 0.1);
  padding: 2rem 0;
  margin-bottom: 2rem;
}

.container {
  max-width: 1200px;
  margin: 0 auto;
  padding: 0 2rem;
}


.title {
  margin: 0;
  font-size: 2.5rem;
  font-weight: 700;
  background: linear-gradient(135deg, #8b5cf6, #d946ef);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-clip: text;
}

.top-section {
  display: grid;
  grid-template-columns: 400px 1fr;
  gap: 1.5rem;
  margin-bottom: 2rem;
}

.donors-section {
  margin-bottom: 2rem;
}

.status-card,
.occupancy-card,
.donors-card {
  background: rgba(255, 255, 255, 0.05);
  border-radius: 16px;
  padding: 1.5rem;
  border: 1px solid rgba(255, 255, 255, 0.1);
  transition: all 0.3s ease;
}

.status-card:hover,
.occupancy-card:hover,
.donors-card:hover {
  background: rgba(255, 255, 255, 0.08);
  border-color: rgba(139, 92, 246, 0.3);
}

.status-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 1rem;
}

.status-card h2,
.occupancy-card h2,
.donors-card h2 {
  margin: 0 0 1rem 0;
  font-size: 1.3rem;
  font-weight: 600;
}

.edit-status-btn {
  background: rgba(139, 92, 246, 0.2);
  color: #c084fc;
  border: 1px solid rgba(139, 92, 246, 0.3);
  border-radius: 8px;
  padding: 0.5rem 1rem;
  font-size: 0.85rem;
  font-weight: 500;
  cursor: pointer;
  transition: all 0.3s ease;
}

.edit-status-btn:hover {
  background: rgba(139, 92, 246, 0.3);
  border-color: rgba(139, 92, 246, 0.5);
}

.status-content {
  display: flex;
  flex-direction: column;
  gap: 0.75rem;
}

.status-indicator {
  display: flex;
  align-items: center;
  gap: 0.5rem;
  font-size: 1rem;
  font-weight: 600;
  padding: 0.75rem;
  border-radius: 8px;
  background: rgba(255, 255, 255, 0.05);
}

.status-indicator.open {
  color: #4ade80;
}

.status-indicator.closed {
  color: #f87171;
}

.status-dot {
  width: 12px;
  height: 12px;
  border-radius: 50%;
  background: currentColor;
  animation: pulse 2s ease-in-out infinite;
}

@keyframes pulse {
  0%, 100% { opacity: 1; }
  50% { opacity: 0.5; }
}

.key-holder {
  display: flex;
  align-items: center;
  gap: 0.5rem;
  color: rgba(255, 255, 255, 0.7);
  padding: 0.75rem;
  border-radius: 8px;
  background: rgba(255, 255, 255, 0.05);
  font-size: 0.9rem;
}

.transfer-btn {
  background: linear-gradient(135deg, #8b5cf6, #d946ef);
  color: white;
  border: none;
  border-radius: 8px;
  padding: 0.75rem 1rem;
  font-size: 0.9rem;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.3s ease;
  box-shadow: 0 4px 12px rgba(139, 92, 246, 0.3);
}

.transfer-btn:hover {
  transform: translateY(-2px);
  box-shadow: 0 6px 20px rgba(139, 92, 246, 0.4);
}

.current-status {
  display: flex;
  align-items: center;
  gap: 1rem;
  padding: 0.75rem;
  border-radius: 8px;
  margin-bottom: 1rem;
  background: rgba(255, 255, 255, 0.05);
}

.current-status.low {
  border-left: 4px solid #4ade80;
}

.current-status.medium {
  border-left: 4px solid #fbbf24;
}

.current-status.high {
  border-left: 4px solid #f87171;
}

.current-time {
  font-size: 1.2rem;
  font-weight: 700;
  color: white;
}

.current-label {
  font-size: 0.9rem;
  color: rgba(255, 255, 255, 0.7);
}

.days-selector {
  display: flex;
  gap: 0.5rem;
  margin-bottom: 1rem;
}

.day-btn {
  flex: 1;
  background: rgba(255, 255, 255, 0.05);
  color: rgba(255, 255, 255, 0.6);
  border: 1px solid rgba(255, 255, 255, 0.1);
  border-radius: 8px;
  padding: 0.6rem;
  font-size: 0.85rem;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.3s ease;
}

.day-btn:hover {
  background: rgba(255, 255, 255, 0.1);
  color: rgba(255, 255, 255, 0.8);
}

.day-btn.active {
  background: rgba(139, 92, 246, 0.3);
  color: #c084fc;
  border-color: rgba(139, 92, 246, 0.5);
}

.chart {
  position: relative;
}

.chart-bars {
  display: flex;
  align-items: flex-end;
  justify-content: space-between;
  height: 150px;
  gap: 3px;
  margin-bottom: 0.75rem;
}

.bar-wrapper {
  flex: 1;
  display: flex;
  align-items: flex-end;
  height: 100%;
}

.bar {
  width: 100%;
  background: linear-gradient(to top, #6366f1, #8b5cf6);
  border-radius: 4px 4px 0 0;
  transition: all 0.3s ease;
  min-height: 2px;
}

.bar.current {
  background: linear-gradient(to top, #8b5cf6, #d946ef);
  box-shadow: 0 0 20px rgba(139, 92, 246, 0.5);
}

.bar:hover {
  opacity: 0.8;
}

.chart-labels {
  display: flex;
  justify-content: space-between;
  color: rgba(255, 255, 255, 0.5);
  font-size: 0.8rem;
}

.donors-list {
  display: flex;
  flex-direction: column;
  gap: 0.75rem;
}

.donor-item {
  display: flex;
  align-items: center;
  gap: 1rem;
  padding: 0.75rem;
  background: rgba(255, 255, 255, 0.03);
  border-radius: 12px;
  transition: all 0.3s ease;
}

.donor-item:hover {
  background: rgba(255, 255, 255, 0.06);
  transform: translateX(4px);
}

.donor-rank {
  width: 36px;
  height: 36px;
  display: flex;
  align-items: center;
  justify-content: center;
  background: linear-gradient(135deg, #8b5cf6, #d946ef);
  border-radius: 50%;
  font-weight: 700;
  font-size: 1rem;
}

.donor-info {
  flex: 1;
}

.donor-name {
  font-weight: 600;
  font-size: 1rem;
  margin-bottom: 0.25rem;
}

.donor-contribution {
  color: rgba(255, 255, 255, 0.6);
  font-size: 0.85rem;
}

.modal-overlay {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: rgba(0, 0, 0, 0.8);
  display: flex;
  align-items: center;
  justify-content: center;
  z-index: 1000;
  padding: 1rem;
}

.modal {
  background: #2d2d2d;
  border-radius: 16px;
  max-width: 500px;
  width: 100%;
  border: 1px solid rgba(255, 255, 255, 0.1);
}

.modal-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 1.5rem;
  border-bottom: 1px solid rgba(255, 255, 255, 0.1);
}

.modal-header h3 {
  margin: 0;
  font-size: 1.5rem;
  font-weight: 600;
}

.close-btn {
  background: none;
  border: none;
  color: rgba(255, 255, 255, 0.6);
  cursor: pointer;
  padding: 0;
  display: flex;
  align-items: center;
  justify-content: center;
  transition: color 0.3s ease;
}

.close-btn:hover {
  color: white;
}

.modal-form {
  padding: 1.5rem;
}

.form-group {
  margin-bottom: 1.5rem;
}

.form-group label {
  display: block;
  margin-bottom: 0.5rem;
  color: rgba(255, 255, 255, 0.8);
  font-weight: 500;
}

.form-group input {
  width: 100%;
  background: rgba(255, 255, 255, 0.05);
  border: 1px solid rgba(255, 255, 255, 0.1);
  border-radius: 8px;
  padding: 0.75rem;
  color: white;
  font-size: 1rem;
  transition: all 0.3s ease;
}

.form-group input:focus {
  outline: none;
  border-color: rgba(139, 92, 246, 0.5);
  background: rgba(255, 255, 255, 0.08);
}

.submit-btn {
  width: 100%;
  background: linear-gradient(135deg, #8b5cf6, #d946ef);
  color: white;
  border: none;
  border-radius: 12px;
  padding: 1rem;
  font-size: 1rem;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.3s ease;
}

.submit-btn:hover {
  transform: translateY(-2px);
  box-shadow: 0 6px 20px rgba(139, 92, 246, 0.4);
}

.status-options {
  padding: 1.5rem;
  display: flex;
  flex-direction: column;
  gap: 1rem;
}

.status-option {
  display: flex;
  align-items: center;
  gap: 0.75rem;
  padding: 1rem;
  border-radius: 12px;
  border: 2px solid transparent;
  font-size: 1.1rem;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.3s ease;
}

.status-option.open {
  background: rgba(74, 222, 128, 0.1);
  color: #4ade80;
}

.status-option.open:hover {
  border-color: #4ade80;
  background: rgba(74, 222, 128, 0.2);
}

.status-option.closed {
  background: rgba(248, 113, 113, 0.1);
  color: #f87171;
}

.status-option.closed:hover {
  border-color: #f87171;
  background: rgba(248, 113, 113, 0.2);
}

@media (max-width: 1024px) {
  .top-section {
    grid-template-columns: 1fr;
  }
}

@media (max-width: 768px) {
  .container {
    padding: 0 1rem;
  }

  .title {
    font-size: 2rem;
  }

  .status-header {
    flex-direction: column;
    align-items: flex-start;
    gap: 1rem;
  }

  .days-selector {
    overflow-x: auto;
    flex-wrap: nowrap;
  }

  .day-btn {
    min-width: 60px;
  }

  .chart-bars {
    gap: 2px;
  }
}
</style>
