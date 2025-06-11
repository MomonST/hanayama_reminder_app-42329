
import "@hotwired/turbo-rails"
import "@hotwired/stimulus"
import "controllers"
// Bootstrap を importmap 経由で読み込む
import * as bootstrap from "bootstrap"
import "jquery"

// グローバル変数
window.HanayamaReminder = window.HanayamaReminder || {}; // 複数箇所で定義されないよう調整

// ページ読み込み時の処理
document.addEventListener('turbo:load', () => {
  initializeApp();
});

// アプリケーション初期化
function initializeApp() {
  initNotificationPopup()
  initImagePreview()
  initLikeButtons()
  initFavoriteButtons()
  initFormValidation()
  initTooltips()
  initScrollAnimations()
  initMobileMenu()
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

// 画像プレビューをクリア (HTMLからも呼び出されるため、グローバルに公開)
window.clearImagePreview = function() {
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
            this.classList.remove('btn-outline-light'); // `link_to` では手動でクラスを操作
            this.classList.add('btn-danger');
            icon.classList.add('text-white'); // ハートの色を白に
          } else {
            icon.classList.remove('bi-heart-fill');
            icon.classList.add('bi-heart');
            this.classList.remove('liked');
            this.classList.remove('btn-danger'); // `link_to` では手動でクラスを操作
            this.classList.add('btn-outline-light');
            icon.classList.remove('text-white'); // ハートの色をデフォルトに戻す
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

// お気に入りボタンの処理
function initFavoriteButtons() {
  const favoriteButtons = document.querySelectorAll(".favorite-button");

  favoriteButtons.forEach((button) => {
    button.addEventListener("click", function (e) {
      e.preventDefault();

      if (this.dataset.processing === "true") {
        return;
      }

      this.dataset.processing = "true"
      const icon = this.querySelector("i")
      const countElement = this.querySelector(".favorite-count")

      // Ajax リクエスト
      fetch(this.href, {
        method: "POST",
        headers: {
          "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]').content,
          Accept: "application/json",
          "Content-Type": "application/json",
        },
        credentials: "same-origin",
      })
        .then((response) => {
          return response.json();
        })
        .then((data) => {
          if (data.success) {
            // お気に入り状態を更新
            if (data.favorited) {
              this.classList.remove("btn-outline-warning")
              this.classList.add("btn-warning")
              icon.classList.remove("far")
              icon.classList.add("fas")
            } else {
              this.classList.remove("btn-warning")
              this.classList.add("btn-outline-warning")
              icon.classList.remove("fas")
              icon.classList.add("far")
            }

            // カウント更新
            if (countElement) {
              countElement.textContent = data.favorites_count
            }

            showAlert(data.message, "success")
          } else {
            showAlert("エラーが発生しました", "danger")
          }
        })
        .catch((error) => {
          showAlert("エラーが発生しました", "danger");
        })
        .finally(() => {
          this.dataset.processing = "false";
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

// アラート表示 (他の場所からも呼び出されるため、グローバルスコープに残すか、特定のモジュールからexportする)
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

// 地図初期化（Google Maps）はapplication.html.erb移動

// マーカーを地図に追加はapplication.html.erb移動

// InfoWindow のコンテンツ作成はapplication.html.erb移動

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

// スムーズスクロール (HTMLからも呼び出されるため、グローバルに公開)
window.smoothScrollTo = function(target) {
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

// 初期化完了後の処理 (DOMContentLoaded は turbo:load とは異なるタイミングで発火)
document.addEventListener('DOMContentLoaded', function() {
  // Turbo環境下でDOMReadyに依存する処理は turbo:load に移行するか、
  // DOMContentLoadedとturbo:loadの両方で初期化関数を呼び出すなど工夫が必要
  initLazyLoading();
  initBeforeUnload();
});
