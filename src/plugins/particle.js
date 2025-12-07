(() => {
  const cvs = document.getElementById('particle-cvs');
  const ctx = cvs.getContext('2d');
  let W = (cvs.width = innerWidth);
  let H = (cvs.height = innerHeight);

  addEventListener('resize', () => {
    W = cvs.width = innerWidth;
    H = cvs.height = innerHeight;
  });

  const particles = [];
  class P {
    constructor(x, y) {
      this.x = x;
      this.y = y;
      this.r = Math.random() * 2 + 1;      // 半径
      this.vx = (Math.random() - 0.5) * 2; // 初速度
      this.vy = (Math.random() - 0.5) * 2;
      this.life = 1;                       // 透明度
      this.decay = 0.015;                  // 消退速度
      this.color = `hsl(${Math.random() * 60 + 180}, 100%, 70%)`;
    }
    update() {
      this.x += this.vx;
      this.y += this.vy;
      this.life -= this.decay;
    }
    draw() {
      ctx.beginPath();
      ctx.arc(this.x, this.y, this.r, 0, Math.PI * 2);
      ctx.fillStyle = this.color.replace(')', `, ${this.life})`);
      ctx.fill();
    }
  }

  let mouseX = 0, mouseY = 0;
  addEventListener('mousemove', e => {
    mouseX = e.clientX;
    mouseY = e.clientY;
    // 每移动 30px 补一颗，密度可调
    if (particles.length < 60) particles.push(new P(mouseX, mouseY));
  });

  function animate() {
    ctx.clearRect(0, 0, W, H);
    for (let i = particles.length - 1; i >= 0; i--) {
      const p = particles[i];
      p.update();
      p.draw();
      if (p.life <= 0) particles.splice(i, 1);
    }
    requestAnimationFrame(animate);
  }
  animate();
})();