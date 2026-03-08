# embtool-toolchains

NXP MCUXpresso ARM GCC 툴체인 메타데이터 및 관리 스크립트.

## 구조

```
versions.json          ← embtool이 읽는 버전/URL 메타데이터
scripts/
├── extract-linux.sh   ← MCUXpresso .deb.bin → tools/ 추출
└── upload-r2.sh       ← Cloudflare R2 업로드
```

## 지원 버전

| 버전 | GCC | Windows | Linux | 출처 |
|------|-----|---------|-------|------|
| 14.2.1 | 14.2.1 | ✅ | ✅ | MCUXpresso IDE 25.6.136 |
| 13.2.1 | 13.2.1 | ✅ | - | MCUXpresso IDE (NXP SDK) |

## 툴체인 내용

ARM 공식 GCC + NXP 확장:
- `redlib/` — NXP RedLib C 라이브러리
- `features/` — NXP 전용 헤더 (crp.h 등)
- `nano.specs` / `nosys.specs` — NXP 패키징 newlib-nano

## 라이선스

- 툴체인 바이너리: NXP LA_OPT_NXP_Software_License (사내 사용)
- GCC/binutils/GDB: GPL v3
- newlib: BSD
- 이 리포의 스크립트: MIT

## 새 버전 추가

1. MCUXpresso IDE를 NXP에서 다운로드
2. `scripts/extract-linux.sh`로 tools/ 추출
3. `scripts/upload-r2.sh`로 R2에 업로드
4. `versions.json` 업데이트
