//= require jquery3
//= require popper
//= require bootstrap-sprockets
//= require rails-ujs
//= require turbolinks
//= require_tree .
import "@hotwired/turbo-rails"
import "@hotwired/stimulus"
import "controllers"
import * as bootstrap from "bootstrap"
import * as google from "googlemaps"

// グローバル変数
window.HanayamaReminder = {
  map: null,
  markers: []
};

// ページ読み込み時の処理
document.addEventListener('turbolinks:load', function() {
  initializeApp();
});

// アプリケーション初期化
function initializeApp() {
  initNotificationPopup();
  initImagePreview();
  initLikeButtons();
  initFormValidation();
  initTooltips();
  initScrollAnimations();
  initMobileMenu();
}

// 通知ポップアップ
function initNotificationPopup() {
  const popup = document.querySelector('.notification-popup');
  if (popup) {
    setTimeout(() => {
      popup.classList.add('show');
    }, 1000);
    
    // 自動で閉じる
    setTimeout(() => {
      popup.classList.remove('show');
    }, 8000);
  }
}

// 画像プレビュー
function initImagePreview() {
  const imageInputs = document.querySelectorAll('input[type="file"][accept*="image"]');
  
  imageInputs.forEach(input => {
    input.addEventListener('change', function(e) {
      const file = e.target.files[0];
      const previewContainer = document.getElementById('image-preview');
      
      if (file && previewContainer) {
        const reader = new FileReader();
        
        reader.onload = function(e) {
          previewContainer.innerHTML = `
            <div class="position-relative d-inline-block">
              <img src="${e.target.result}" class="img-thumbnail" style="max-height: 200px; max-width: 300px;">
              <button type="button" class="btn btn-sm btn-danger position-absolute top-0 end-0 m-1" onclick="clearImagePreview()">
                <i class="bi bi-x"></i>
              </button>
            </div>
          `;
          previewContainer.classList.remove('d-none');
        };
        
        reader.readAsDataURL(file);
      }
    });
  });
}

// 画像プレビューをクリア
function clearImagePreview() {
  const previewContainer = document.getElementById('image-preview');
  const fileInput = document.querySelector('input[type="file"][accept*="image"]');
  
  if (previewContainer) {
    previewContainer.innerHTML = '';
    previewContainer.classList.add('d-none');
  }
  
  if (fileInput) {
    fileInput.value = '';
  }
}

// いいねボタンの処理
function initLikeButtons() {
  const likeButtons = document.querySelectorAll('.like-button');
  
  likeButtons.forEach(button => {
    button.addEventListener('click', function(e) {
      e.preventDefault();
      
      if (this.dataset.processing === 'true') return;
      
      this.dataset.processing = 'true';
      const icon = this.querySelector('i');
      const countElement = this.querySelector('.like-count');
      
      // アニメーション
      icon.classList.add('animate__animated', 'animate__heartBeat');
      
      // Ajax リクエスト
      fetch(this.href, {
        method: this.dataset.method || 'POST',
        headers: {
          'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').content,
          'Accept': 'application/json',
          'Content-Type': 'application/json'
        },
        credentials: 'same-origin'
      })
      .then(response => response.json())
      .then(data => {
        if (data.success) {
          // いいね状態を更新
          if (data.liked) {
            icon.classList.remove('bi-heart');
            icon.classList.add('bi-heart-fill');
            this.classList.add('liked');
          } else {
            icon.classList.remove('bi-heart-fill');
            icon.classList.add('bi-heart');
            this.classList.remove('liked');
          }
          
          // カウント更新
          if (countElement) {
            countElement.textContent = data.likes_count;
          }
        }
      })
      .catch(error => {
        console.error('Error:', error);
        showAlert('エラーが発生しました', 'danger');
      })
      .finally(() => {
        this.dataset.processing = 'false';
        setTimeout(() => {
          icon.classList.remove('animate__animated', 'animate__heartBeat');
        }, 1000);
      });
    });
  });
}

// フォームバリデーション
function initFormValidation() {
  const forms = document.querySelectorAll('.needs-validation');
  
  forms.forEach(form => {
    form.addEventListener('submit', function(e) {
      if (!form.checkValidity()) {
        e.preventDefault();
        e.stopPropagation();
      }
      
      form.classList.add('was-validated');
    });
  });
}

// ツールチップ初期化
function initTooltips() {
  const tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'));
  tooltipTriggerList.map(function (tooltipTriggerEl) {
    return new bootstrap.Tooltip(tooltipTriggerEl);
  });
}

// スクロールアニメーション
function initScrollAnimations() {
  const observerOptions = {
    threshold: 0.1,
    rootMargin: '0px 0px -50px 0px'
  };
  
  const observer = new IntersectionObserver((entries) => {
    entries.forEach(entry => {
      if (entry.isIntersecting) {
        entry.target.classList.add('fade-in-up');
      }
    });
  }, observerOptions);
  
  // アニメーション対象要素を監視
  document.querySelectorAll('.card, .feature-icon').forEach(el => {
    observer.observe(el);
  });
}

// モバイルメニュー
function initMobileMenu() {
  const navbarToggler = document.querySelector('.navbar-toggler');
  const navbarCollapse = document.querySelector('.navbar-collapse');
  
  if (navbarToggler && navbarCollapse) {
    // メニュー外をクリックで閉じる
    document.addEventListener('click', function(e) {
      if (!navbarCollapse.contains(e.target) && !navbarToggler.contains(e.target)) {
        const bsCollapse = bootstrap.Collapse.getInstance(navbarCollapse);
        if (bsCollapse && navbarCollapse.classList.contains('show')) {
          bsCollapse.hide();
        }
      }
    });
  }
}

// アラート表示
function showAlert(message, type = 'info') {
  const alertContainer = document.getElementById('alert-container') || createAlertContainer();
  
  const alertElement = document.createElement('div');
  alertElement.className = `alert alert-${type} alert-dismissible fade show`;
  alertElement.innerHTML = `
    ${message}
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
  `;
  
  alertContainer.appendChild(alertElement);
  
  // 自動で削除
  setTimeout(() => {
    if (alertElement.parentNode) {
      alertElement.remove();
    }
  }, 5000);
}

// アラートコンテナ作成
function createAlertContainer() {
  const container = document.createElement('div');
  container.id = 'alert-container';
  container.className = 'position-fixed top-0 end-0 p-3';
  container.style.zIndex = '1055';
  document.body.appendChild(container);
  return container;
}

// 地図初期化（Google Maps）
function initMap() {
  const mapElement = document.getElementById('map');
  if (!mapElement) return;
  
  const center = { lat: 36.2048, lng: 138.2529 };
  
  HanayamaReminder.map = new google.maps.Map(mapElement, {
    zoom: 6,
    center: center,
    styles: [
      {
        featureType: 'all',
        elementType: 'geometry.fill',
        stylers: [{ color: '#f0f9ff' }]
      },
      {
        featureType: 'water',
        elementType: 'geometry',
        stylers: [{ color: '#a7c6ed' }]
      }
    ]
  });
  
  // マーカーデータを取得して表示
  if (window.mapData) {
    addMarkersToMap(window.mapData);
  }
}

// マーカーを地図に追加
function addMarkersToMap(locations) {
  const bounds = new google.maps.LatLngBounds();
  
  locations.forEach(location => {
    if (location.lat && location.lng) {
      const marker = new google.maps.Marker({
        position: { lat: parseFloat(location.lat), lng: parseFloat(location.lng) },
        map: HanayamaReminder.map,
        title: location.name,
        icon: {
          url: 'data:image/svg+xml;charset=UTF-8,' + encodeURIComponent(`
            <svg width="32" height="32" viewBox="0 0 32 32" xmlns="http://www.w3.org/2000/svg">
              <circle cx="16" cy="16" r="12" fill="#22c55e" stroke="#fff" stroke-width="2"/>
              <text x="16" y="20" text-anchor="middle" fill="white" font-size="16">🌸</text>
            </svg>
          `),
          scaledSize: new google.maps.Size(32, 32)
        }
      });
      
      const infoWindow = new google.maps.InfoWindow({
        content: createInfoWindowContent(location)
      });
      
      marker.addListener('click', () => {
        // 他のInfoWindowを閉じる
        HanayamaReminder.markers.forEach(m => {
          if (m.infoWindow) m.infoWindow.close();
        });
        
        infoWindow.open(HanayamaReminder.map, marker);
      });
      
      HanayamaReminder.markers.push({ marker, infoWindow });
      bounds.extend(marker.getPosition());
    }
  });
  
  // 地図の表示範囲を調整
  if (HanayamaReminder.markers.length > 0) {
    HanayamaReminder.map.fitBounds(bounds);
    
    // ズームが近すぎる場合は調整
    google.maps.event.addListenerOnce(HanayamaReminder.map, 'bounds_changed', () => {
      if (HanayamaReminder.map.getZoom() > 12) {
        HanayamaReminder.map.setZoom(12);
      }
    });
  }
}

// InfoWindow のコンテンツ作成
function createInfoWindowContent(location) {
  return `
    <div style="padding: 10px; max-width: 250px; font-family: 'Helvetica Neue', Arial, sans-serif;">
      <h5 style="margin: 0 0 8px 0; color: #1f2937; font-weight: 600;">${location.name}</h5>
      <p style="margin: 4px 0; color: #6b7280; font-size: 14px;">
        <strong>🌸 花:</strong> ${location.flower}
      </p>
      <p style="margin: 4px 0; color: #6b7280; font-size: 14px;">
        <strong>📍 難易度:</strong> ${location.difficulty || '未設定'}
      </p>
      ${location.days_left ? `
        <p style="margin: 4px 0; color: #22c55e; font-size: 14px; font-weight: 600;">
          <strong>⏰ 見頃まで:</strong> あと${location.days_left}日
        </p>
      ` : ''}
      <div style="margin-top: 12px;">
        <a href="/flower_mountains/${location.id}" 
           style="background: linear-gradient(135deg, #22c55e, #16a34a); 
                  color: white; 
                  padding: 6px 12px; 
                  border-radius: 6px; 
                  text-decoration: none; 
                  font-size: 13px; 
                  font-weight: 500;">
          詳細を見る
        </a>
      </div>
    </div>
  `;
}

// ローディング表示
function showLoading(element) {
  if (element) {
    element.innerHTML = '<div class="text-center py-4"><div class="loading"></div></div>';
  }
}

// ローディング非表示
function hideLoading(element, content) {
  if (element) {
    element.innerHTML = content;
  }
}

// スムーススクロール
function smoothScrollTo(target) {
  const element = document.querySelector(target);
  if (element) {
    element.scrollIntoView({
      behavior: 'smooth',
      block: 'start'
    });
  }
}

// 画像遅延読み込み
function initLazyLoading() {
  const images = document.querySelectorAll('img[data-src]');
  
  const imageObserver = new IntersectionObserver((entries) => {
    entries.forEach(entry => {
      if (entry.isIntersecting) {
        const img = entry.target;
        img.src = img.dataset.src;
        img.classList.remove('lazy');
        imageObserver.unobserve(img);
      }
    });
  });
  
  images.forEach(img => imageObserver.observe(img));
}

// ページ離脱時の確認
function initBeforeUnload() {
  const forms = document.querySelectorAll('form');
  let formChanged = false;
  
  forms.forEach(form => {
    form.addEventListener('input', () => {
      formChanged = true;
    });
    
    form.addEventListener('submit', () => {
      formChanged = false;
    });
  });
  
  window.addEventListener('beforeunload', (e) => {
    if (formChanged) {
      e.preventDefault();
      e.returnValue = '';
    }
  });
}

// 初期化完了後の処理
document.addEventListener('DOMContentLoaded', function() {
  initLazyLoading();
  initBeforeUnload();
});