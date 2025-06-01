//= require jquery3
//= require popper
//= require bootstrap
//= require rails-ujs
//= require turbolinks
//= require_tree .

// ページ読み込み時の処理
document.addEventListener('turbolinks:load', function() {
  // 通知ポップアップ
  const notificationPopup = document.getElementById('notification-popup');
  if (notificationPopup) {
    setTimeout(function() {
      notificationPopup.classList.add('show');
    }, 1000);
  }
  
  // 画像プレビュー（投稿フォーム）
  const postImage = document.getElementById('post-image');
  if (postImage) {
    postImage.addEventListener('change', function(e) {
      const preview = document.getElementById('image-preview');
      const previewImg = preview.querySelector('img');
      
      if (this.files && this.files[0]) {
        const reader = new FileReader();
        
        reader.onload = function(e) {
          previewImg.src = e.target.result;
          preview.classList.remove('d-none');
        }
        
        reader.readAsDataURL(this.files[0]);
      } else {
        preview.classList.add('d-none');
      }
    });
  }
  
  // いいねボタンの非同期処理
  const likeButtons = document.querySelectorAll('.like-button');
  if (likeButtons.length > 0) {
    likeButtons.forEach(button => {
      button.addEventListener('click', function(e) {
        if (!this.dataset.remote) return;
        
        e.preventDefault();
        const url = this.getAttribute('href');
        const method = this.dataset.method || 'post';
        
        fetch(url, {
          method: method,
          headers: {
            'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').content,
            'Accept': 'application/javascript'
          },
          credentials: 'same-origin'
        })
        .then(response => {
          if (response.ok) {
            return response.text();
          }
          throw new Error('Network response was not ok.');
        })
        .then(html => {
          // Rails UJSの応答を処理
          const scriptTag = document.createElement('script');
          scriptTag.innerHTML = html;
          document.body.appendChild(scriptTag);
        })
        .catch(error => {
          console.error('Error:', error);
        });
      });
    });
  }
});